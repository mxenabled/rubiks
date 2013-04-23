# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubiks/version'

Gem::Specification.new do |gem|
  gem.name          = 'rubiks'
  gem.version       = Rubiks::VERSION
  gem.authors       = ['JohnnyT']
  gem.email         = ['johnnyt@moneydesktop.com']
  gem.summary       = %q{A gem to provide translation of OLAP schemas}
  gem.description   = %q{A gem to allow defining an OLAP schema from a hash and generate an XML schema for Mondrian}
  gem.homepage      = 'https://github.com/moneydesktop/rubiks'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'active_attr'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'builder'

  # Check the Gemfile for test and development dependencies
end
