require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/module/introspection'
require 'active_support/core_ext/hash/deep_dup'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/conversions'
require 'builder'
require 'multi_json'
require 'active_attr'

require 'rubiks/version'

module ::Rubiks
  autoload :Cube, 'rubiks/cube'
  autoload :Hierarchy, 'rubiks/hierarchy'
  autoload :Dimension, 'rubiks/dimension'
  autoload :Schema, 'rubiks/schema'
  autoload :Level, 'rubiks/level'
  autoload :NamedObject, 'rubiks/named_object'
  autoload :Measure, 'rubiks/measure'
  autoload :CalculatedMeasure, 'rubiks/calculated_measure'

  def self.connection
    Rubiks::Mondrian.connection
  end

  def self.clear_cache
    ::Rubiks::Mondrian.flush_schema_cache
    ::Rubiks::Mondrian.reset_connection
  end

  def self.execute(query)
    ::Rubiks::Mondrian.connection.execute(query)
  end

  def self.schema
    @schema ||= ::Rubiks::Schema.default
  end
end
