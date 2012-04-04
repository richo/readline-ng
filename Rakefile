require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/*_spec.rb"
end

desc 'Default: run specs'
task :default => :spec

task(:build) do
  sh "gem build readline-ng.gemspec"
end

task(:clean) do
  Dir["*.gem"].each do |gem|
    sh "rm #{gem}"
  end
end
