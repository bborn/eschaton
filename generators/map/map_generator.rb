class MapGenerator < Rails::Generator::Base
  attr_reader :plugin_class
  
  def manifest
    record do |m|
      m.file "jquery.js", "public/javascripts/jquery.js"

      m.file "map_controller.rb", "app/controllers/map_controller.rb"
      m.file "map_helper.rb", "app/helpers/map_helper.rb"

      m.directory "app/views/map"
      m.file "map.erb", "app/views/layouts/map.erb"
      m.file "index.erb", "app/views/map/index.erb"
      
      # Marker icons
      m.file "blue.png", "public/images/blue.png"
      m.file "red.png", "public/images/red.png"
      m.file "yellow.png", "public/images/yellow.png"
      m.file "shadow.png", "public/images/shadow.png"

      # Eschaton plugin
      plugin_name = File.basename(RAILS_ROOT).singularize.downcase
      @plugin_class = plugin_name.classify
      plugin_dir = "lib/eschaton_plugins/#{plugin_name}"

      m.directory plugin_dir

      m.template "generator_ext.rb", "#{plugin_dir}/#{plugin_name}_generator_ext.rb" 
      m.template "view_ext.rb", "#{plugin_dir}/#{plugin_name}_view_ext.rb"
    end
  end

end