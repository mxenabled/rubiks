require 'rubygems'
require 'bundler'
require 'pry'

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'rubiks'

Bundler.require(:default, :development, :test)
