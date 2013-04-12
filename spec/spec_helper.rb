require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'rubiks'
require 'rspec'
require 'pry-debugger' if ENV['DEBUG']

require 'support/schema_context'
require 'support/matchers/be_like'

RSpec.configure do |config|
  config.include Matchers
end
