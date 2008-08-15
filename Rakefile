require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'test/test_helper'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the eschaton plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the eschaton plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'eschaton'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')

  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include("plugins/*/**/*.rb")  
end
