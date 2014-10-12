require 'rubygems'
require 'rubygems/specification.rb'
require 'rubygems/command.rb'
require 'rubygems/dependency_installer.rb' 
begin
  Gem::Command.build_args = ARGV
rescue NoMethodError
end 
inst = Gem::DependencyInstaller.new
rails_matches = Gem::Specification.find_by_name('rails')
begin
  inst.install("responders", "~> 2.0") if rails_matches.version.to_s >= '4.2.0'
rescue Exception => e
  f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")
  f.write(e)
  f.close
  exit(1)
end
