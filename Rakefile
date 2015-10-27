#!/usr/bin/env rake
require 'foodcritic'
require 'rake'

desc "Runs knife cookbook test"
task :knife do
  sh "bundle exec knife cookbook test cookbook -o ./ -a"
end

desc "Runs foodcritic test"
task :foodcritic do
  FoodCritic::Rake::LintTask.new
  sh "bundle exec foodcritic -f any ."
end

desc "Runs rubocop checks"
task :rubocop do
  sh "bundle exec rubocop --fail-level warn"
end

desc "Package Berkshelf distro"
task :dist do
  sh "rm -rf Berksfile.lock cookbooks-*.tar.gz; bundle exec berks package; rm -f cookbooks-*.tar.gz"
end

task :default => [:foodcritic, :rubocop, :knife, :dist]
