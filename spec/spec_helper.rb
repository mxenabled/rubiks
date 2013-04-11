#lib_path = File.expand_path("../../lib", __FILE__)
#$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)
#
## Don't use simplecov in ruby 1.8
#if RUBY_VERSION !~ /^1\.8/
#  begin
#    require 'simplecov'
#    SimpleCov.start do
#      add_filter '/spec/'
#    end
#  rescue LoadError
#  end
#end
#
#require 'bundler'
#Bundler.require(:default, :development, :test)
#
#require 'rubiks'
#
#RSpec.configure do |config|
#  config.include Matchers
#end

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'rubiks'
require 'rspec'

require 'support/schema_context'
require 'support/matchers/be_like'

RSpec.configure do |config|
  config.include Matchers
end
