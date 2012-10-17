# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubiks/version'

Gem::Specification.new do |gem|
  gem.name          = 'rubiks'
  gem.version       = Rubiks::VERSION
  gem.authors       = ['JohnnyT']
  gem.email         = ['johnnyt@moneydesktop.com']
  gem.description   = %q{OLAP Cube layer in Ruby}
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/moneydesktop/rubiks'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake'
end
