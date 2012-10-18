require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'test/**/test_*.rb'
  t.libs.push 'test'
end

task :default => :test
