require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require File.dirname(__FILE__) + '/../../../config/environment'
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
end

# Generate a rake task for each plugin separately
#  - rdocs
#  - run all tests
PluginLoader.plugin_locations.each do |plugin_directory|
  plugin_name = File.basename(plugin_directory)
        
  desc "Test the '#{plugin_name}' eschaton plugin."
  Rake::TestTask.new("test_#{plugin_name}") do |t|

    #t.libs << 'lib'
    t.pattern = "#{plugin_directory}/test/*_test.rb"
    t.verbose = true
  end
        
  desc "Generate documentation for '#{plugin_name}' eschaton plugin."
  Rake::RDocTask.new("doc_#{plugin_name}") do |rdoc|
    rdoc.rdoc_dir = "plugin_docs/#{plugin_name}"
    rdoc.title    = plugin_name
    rdoc.options << '--line-numbers' << '--inline-source'
  
    readme_file = "#{plugin_directory}/README"
    rdoc.rdoc_files.include(readme_file) if File.exists?(readme_file) 
      
    rdoc.rdoc_files.include("#{plugin_directory}/**/*.rb")
  end
end

#desc 'Generate documentation for all the eschaton plugins'
#task :doc_plugins do 
#  PluginLoader.plugin_locations.each do |plugin_directory|
#    Rake::Task["doc_#{File.basename(plugin_directory)}"].invoke
#  end
#end