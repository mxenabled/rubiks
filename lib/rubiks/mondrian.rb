require 'java'
require 'rubiks/mondrian_connection'

# Require all jars in lib/rubiks/jars
Dir[File.expand_path('../jars/*.jar', __FILE__)].each{ |jar| require jar }
#Dir[File.expand_path('../saiku_jars/*.jar', __FILE__)].each{ |jar| require jar }

# register Mondrian olap4j driver
Java::mondrian.olap4j.MondrianOlap4jDriver

module ::Rubiks
  def self.connection
    @connection ||= ::Rubiks::Mondrian.connection
  end

  class Mondrian
    def self.connection
      @connection ||= ::Rubiks::MondrianConnection.create(
        config.merge(:catalog_content => ::Rubiks.schema.to_xml)
      )
    end

    def self.config=(new_config)
      @config = new_config
    end

    def self.config
      @config ||= begin
        if defined?(Rails)
          ar_config = ActiveRecord::Base.connection.config

          {
            :driver           => ar_config[:adapter],
            :host             => ar_config[:host],
            :database         => ar_config[:database],
            :username         => ar_config[:username],
            :password         => ar_config[:password]
          }
        else
          {}
        end
      end
    end
  end
end
