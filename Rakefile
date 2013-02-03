require 'bundler/setup'
require 'rspec/core/rake_task'
require 'yard'

desc 'Default: run specs.'
task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
end

namespace :doorkeeper do
  desc "Install doorkeeper in dummy app"
  task :install do
    cd 'spec/dummy'
    system 'bundle exec rails g doorkeeper:install --force'
  end
end

Bundler::GemHelper.install_tasks
