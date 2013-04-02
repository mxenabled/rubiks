# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubiks/version'

Gem::Specification.new do |gem|
  gem.name          = 'rubiks'
  gem.version       = Rubiks::VERSION
  gem.authors       = ['JohnnyT']
  gem.email         = ['johnnyt@moneydesktop.com']
  gem.description   = %q{Define an OLAP schema}
  gem.summary       = 'Rubiks is a Ruby gem that defines an OLAP schema and can output the schema as XML and JSON.'
  gem.homepage      = 'https://github.com/moneydesktop/rubiks'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'rltk'
  gem.add_dependency 'activesupport'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-pride'

  gem.add_development_dependency 'rb-fsevent'
  gem.add_development_dependency 'guard-rspec'

  gem.add_development_dependency 'awesome_print'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-nav'
  gem.add_development_dependency 'simplecov-gem-adapter'
end
