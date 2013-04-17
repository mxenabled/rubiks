# Currently assumes we are running in a Rails project
# and there is a YAML config file at: RAILS_ROOT/config/rubiks.yml

require 'java'
require 'rubiks/mondrian_connection'

# Require all jars in lib/rubiks/jars
Dir[File.expand_path('../jars/*.jar', __FILE__)].each{ |jar| require jar }

#unless java.lang.System.getProperty("log4j.configuration")
#  file_uri = java.io.File.new("#{root_dir}/config/log4j.properties").toURI.to_s
#  java.lang.System.setProperty("log4j.configuration", file_uri)
#end

# register Mondrian olap4j driver
Java::mondrian.olap4j.MondrianOlap4jDriver

module ::Rubiks

  class Mondrian
    def self.connection
      @connection ||= ::Rubiks::MondrianConnection.create(mondrian_config)
    end

    def self.execute(query)
      connection.execute(query)
    end

    # Currently assumes we are running in a Rails project
    def self.schema
      @schema ||= ::Rubiks::Schema.new_from_hash(YAML.load_file(Rails.root.join('config/rubiks.yml')))
    end

    private

    # Currently assumes we are running in a Rails project
    def self.mondrian_config
      @mondrian_config ||= begin
        ar_config = ActiveRecord::Base.connection.config

        {
          :driver           => ar_config[:adapter],
          :host             => ar_config[:host],
          :database         => ar_config[:database],
          :username         => ar_config[:username],
          :password         => ar_config[:password],
          :catalog_content  => self.schema.to_xml
        }
      end
    end
  end
end
