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
  rdoc.rdoc_files.include("plugins/*/**/*.rb")  
end

desc 'Updates eschaton, related plugins and files.'
task :update do |t|
  update_plugins
  update_javascript
end

def update_plugins
  update_plugin :quiver_core
  update_plugin :eschaton  
end

def update_plugin(name)
  plugins_dir = "#{RAILS_ROOT}/vendor/plugins"
  plugin_dir = "#{plugins_dir}/#{name}"
  git_repo = "#{plugin_dir}/.git"

  puts "updating plugin '#{name}'"  

  repo_exists = File.exists?(git_repo)
  git_results = if repo_exists 
                  `cd #{plugin_dir} && git pull origin master`
                else
                  `rm -rf #{plugin_dir} && cd #{plugins_dir} && git clone git://github.com/yawningman/#{name}.git && rm -rf #{git_repo}`
                end

  puts "git says:"
  puts "========="
  puts git_results
  puts "========="  
  puts ""
end

def update_javascript
  project_dir = RAILS_ROOT + '/public/javascripts/'  
  scripts = Dir['generators/map/templates/*.js']

  FileUtils.cp scripts, project_dir

  puts 'Updated javascripts:'
  scripts.each do |script|
    puts "  #{script}"
  end  
end