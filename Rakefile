require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
desc 'Run all specs'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :test => :spec

task :debug do
  ENV['DEBUG'] = 'true'
  Rake::Task['spec'].invoke
end

require 'yard'
YARD::Rake::YardocTask.new
