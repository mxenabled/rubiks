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
