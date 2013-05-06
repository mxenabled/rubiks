require 'java'
require 'rubiks/mondrian/connection'
require 'rubiks/mondrian/errors'

Dir[File.expand_path('../mondrian/jars/*.jar', __FILE__)].each{ |jar| require jar }

# register Mondrian olap4j driver
Java::mondrian.olap4j.MondrianOlap4jDriver

module ::Rubiks
  module Mondrian
    def self.connection
      @connection ||= ::Rubiks::Mondrian::Connection.create(
        config.merge(:catalog_content => ::Rubiks.schema.to_xml)
      )
    end

    def self.config=(new_config)
      @config = new_config
    end

    def self.config
      @config ||= begin
        if defined?(ActiveRecord)
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

    def self.execute(query)
      connection.execute(query)
    end

    # After the cache is flushed we must reset the connection
    def self.flush_schema_cache
      connection.flush_schema_cache
    end

    def self.reset_connection
      connection.close
      @connection = ::Rubiks::Mondrian::Connection.create(
        config.merge(:catalog_content => ::Rubiks.schema.to_xml)
      )
    end
  end
end
