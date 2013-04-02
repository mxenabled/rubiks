lib_path = File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

begin
  require 'simplecova'
  SimpleCov.start do
    add_filter '/spec/'
  end
rescue LoadError
end

require 'bundler'
Bundler.require(:default, :development, :test)

require 'rubiks'

require 'support/schema_context'
