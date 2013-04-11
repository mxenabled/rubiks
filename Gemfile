source 'http://rubygems.org'

# rubiks.gemspec defines the runtime dependencies
gemspec

# Test and development dependencies are defined here
# so CI can include just test dependencies
group :test do
  gem 'rake'
  gem 'yard'
  gem 'coveralls', :require => false
  gem 'simplecov', :require => false
  gem 'rspec'
end

group :development do
  gem 'awesome_print'
  gem 'kramdown'
  gem 'pry'
  gem 'pry-nav'
end
