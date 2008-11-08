require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'code_statistics'
  
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

desc "Report code statistics (KLOCs, etc) from the application"
task :stats do
  STATS_DIRECTORIES = [
    %w(Controllers        app/controllers),
    %w(Helpers            app/helpers), 
    %w(Models             app/models),
    %w(Libraries          lib/),
    %w(APIs               app/apis),
    %w(Components         components),
    %w(Integration\ tests test/integration),
    %w(Functional\ tests  test/functional),
    %w(Unit\ tests        test/unit)

  ].collect { |name, dir| [ name, "#{RAILS_ROOT}/#{dir}" ] }.select { |name, dir| File.directory?(dir) }  
  
  CodeStatistics.new(*STATS_DIRECTORIES).to_s
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