require 'rake'
require 'rake/testtask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the acts_as_tagging plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
