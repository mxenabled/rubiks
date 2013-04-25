require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'rubiks'
require 'rspec'
require 'equivalent-xml'
require 'json_expressions/rspec'
require 'pry-debugger' if ENV['DEBUG']

Dir['./spec/support/**/*.rb'].sort.each{ |file| require file }

RSpec.configure do |config|
  config.before :each do
    ::Rubiks::Schema.clear!
    ::Rubiks::Cube.clear!
    ::Rubiks::Dimension.clear!
    # ::Rubiks::Hierarchy.clear!
    # ::Rubiks::Level.clear!
  end
end
