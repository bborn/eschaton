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

desc 'Updates eschaton, related plugins and files.'
task :update do
  if update_plugins
    update_javascript
    puts ''
    puts 'Plugins updated, have fun with the latest version.'
  else
    puts ''
    puts "Sorry, couldn't update."
  end
end

desc 'Updates eschaton related javascript files.'
task :update_javascript do
  update_javascript
end

desc 'Clones an eschaton slice from a git repo'
task :clone_slice do
  SliceCloner.clone :repo => ENV['slice']
end

def update_plugins
  update_plugin(:quiver_core) && update_plugin(:eschaton)
end

def update_plugin(name)
  plugins_dir = "#{RAILS_ROOT}/vendor/plugins"
  plugin_dir = "#{plugins_dir}/#{name}"
  git_repo = "#{plugin_dir}/.git"

  puts "updating plugin '#{name}'"  

  git_repo_exists = File.exists?(git_repo)
  stdin, stdout, stderr = if git_repo_exists 
                            Open3.popen3 "cd #{plugin_dir} && git pull origin master"
                          else
                            Open3.popen3 "rm -rf #{plugin_dir} && cd #{plugins_dir} && git clone git://github.com/yawningman/#{name}.git && rm -rf #{git_repo}"
                          end

  output, errors = stdout.read, stderr.read
  ran_successfully = errors.blank?
  
  puts 'git says:'
  puts '========='
  puts output unless output.blank?
  puts errors unless errors.blank?
  puts '========='
  puts ''

  ran_successfully
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