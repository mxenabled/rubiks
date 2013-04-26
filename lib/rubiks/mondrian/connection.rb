# Taken from mondrian-olap: https://github.com/rsim/mondrian-olap/blob/master/lib/mondrian/olap/connection.rb
require 'rubiks/mondrian/cell_set'
require 'rubiks/mondrian/errors'

module ::Rubiks
  module Mondrian

    class Connection
      def self.create(params)
        connection = new(params)
        connection.connect
        connection
      end

      attr_reader :raw_connection, :raw_catalog, :raw_schema

      def initialize(params={})
        @params = params
        @driver = params[:driver]
        @connected = false
        @raw_connection = nil
      end

      def connect
        ::Rubiks::MondrianError.wrap_native_exception do
          # hack to call private constructor of MondrianOlap4jDriver
          # to avoid using DriverManager which fails to load JDBC drivers
          # because of not seeing JRuby required jar files
          cons = Java::MondrianOlap4j::MondrianOlap4jDriver.java_class.declared_constructor
          cons.accessible = true
          driver = cons.new_instance.to_java

          props = java.util.Properties.new
          props.setProperty('JdbcUser', @params[:username]) if @params[:username]
          props.setProperty('JdbcPassword', @params[:password]) if @params[:password]

          conn_string = connection_string
          @raw_jdbc_connection = driver.connect(conn_string, props)

          @raw_connection = @raw_jdbc_connection.unwrap(Java::OrgOlap4j::OlapConnection.java_class)
          @raw_catalog = @raw_connection.getOlapCatalog
          # currently it is assumed that there is just one schema per connection catalog
          @raw_schema = @raw_catalog.getSchemas.first
          @connected = true
          true

          # latest Mondrian version added ClassResolver which uses current thread class loader to load some classes
          # therefore need to set it to JRuby class loader to ensure that Mondrian classes are found
          # (e.g. when running mondrian-olap inside OSGi container)
          current_thread = Java::JavaLang::Thread.currentThread
          class_loader = current_thread.getContextClassLoader
          begin
            current_thread.setContextClassLoader JRuby.runtime.jruby_class_loader
            @raw_jdbc_connection = driver.connect(conn_string, props)
          ensure
            current_thread.setContextClassLoader(class_loader)
          end

          @raw_connection = @raw_jdbc_connection.unwrap(Java::OrgOlap4j::OlapConnection.java_class)
          @raw_catalog = @raw_connection.getOlapCatalog
          # currently it is assumed that there is just one schema per connection catalog
          @raw_schema = @raw_catalog.getSchemas.first
          @connected = true
          true
        end
      end

      def connected?
        @connected
      end

      def close
        @raw_connection.close
        @connected = false
        @raw_connection = @raw_jdbc_connection = nil
        true
      end

      def execute(query_string)
        ::Rubiks::MondrianError.wrap_native_exception do
          statement = @raw_connection.prepareOlapStatement(query_string)
          ::Rubiks::Mondrian::CellSet.new(statement.executeQuery())
        end
      end

      private

      def connection_string
        string = "jdbc:mondrian:Jdbc=#{quote_string(jdbc_uri)};JdbcDrivers=#{jdbc_driver};"
        # by default use content checksum to reload schema when catalog has changed
        string << "UseContentChecksum=true;" unless @params[:use_content_checksum] == false
        if role = @params[:role] || @params[:roles]
          roles = Array(role).map{|r| r && r.to_s.gsub(',', ',,')}.compact
          string << "Role=#{quote_string(roles.join(','))};" unless roles.empty?
        end
        string << (@params[:catalog] ? "Catalog=#{catalog_uri}" : "CatalogContent=#{quote_string(catalog_content)}")
      end

      def jdbc_uri
        "jdbc:#{@driver}://#{@params[:host]}#{@params[:port] && ":#{@params[:port]}"}/#{@params[:database]}"
      end

      def jdbc_driver
        'org.postgresql.Driver'
      end

      def catalog_uri
        if @params[:catalog]
          "file://#{File.expand_path(@params[:catalog])}"
        else
          raise ArgumentError, 'missing catalog source'
        end
      end

      def catalog_content
        if @params[:catalog_content]
          @params[:catalog_content]
        elsif @params[:schema]
          @params[:schema].to_xml(:driver => @driver)
        else
          raise ArgumentError, "Specify catalog with :catalog, :catalog_content or :schema option"
        end
      end

      def quote_string(string)
        "'#{string.gsub("'","''")}'"
      end
    end

  end
end
