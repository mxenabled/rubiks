require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/module/introspection'
require 'active_support/core_ext/hash/deep_dup'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/conversions'
require 'builder'
require 'multi_json'

require 'rubiks/cube'
require 'rubiks/dimension'
require 'rubiks/version'

module ::Rubiks
  autoload :Cube, 'rubiks/cube'
  autoload :Dimension, 'rubiks/dimension'
  autoload :Schema, 'rubiks/schema'
  autoload :UiAttributes, 'rubiks/ui_attributes'
end
