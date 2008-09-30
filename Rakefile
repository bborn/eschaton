require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

# Load up the entire host rails enviroment
require File.dirname(__FILE__) + '/../../../config/environment'

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
  rdoc.rdoc_files.include('README.rdoc')

  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include("slices/*/**/*.rb")
end

desc 'Opens documentation for the eschaton plugin.'
task :open_doc do |rdoc|
  `open rdoc/index.html`
end

desc 'Updates eschaton related javascript files.'
task :update_javascript do
  update_javascript
end

desc 'Clones an eschaton slice from a git repo'
task :clone_slice do
  SliceCloner.clone :repo => ENV['slice']
end

def update_javascript
  project_dir = RAILS_ROOT + '/public/javascripts/'
  scripts = Dir['generators/map/templates/*.js']

  FileUtils.cp scripts, project_dir

  puts 'Updated javascripts:'
  scripts.each do |script|
    puts "  /public/javascripts/#{File.basename(script)}"
  end  
end