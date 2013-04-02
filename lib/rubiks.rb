require 'rubiks/version'

require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/deep_dup'
require 'active_support/core_ext/hash/keys'

nodes_directory = File.expand_path('../rubiks/nodes', __FILE__)
Dir["#{nodes_directory}/*.rb"].each { |file| require file }
