class MapGenerator < Rails::Generator::Base
  attr_reader :slice_class
  
  def manifest
    record do |m|
      # Javascript
      m.file "jquery.js", "public/javascripts/jquery.js"
      m.file "eschaton.js", "public/javascripts/eschaton.js"      

      m.file "map_controller.rb", "app/controllers/map_controller.rb"
      m.file "map_helper.rb", "app/helpers/map_helper.rb"

      m.directory "app/views/map"
      m.file "map.erb", "app/views/layouts/map.erb"
      m.file "index.erb", "app/views/map/index.erb"
      
      # Marker icons
      m.file "blue.png", "public/images/blue.png"
      m.file "red.png", "public/images/red.png"
      m.file "yellow.png", "public/images/yellow.png"
      m.file "green.png", "public/images/green.png"      
      m.file "shadow.png", "public/images/shadow.png"

      # Eschaton slice
      slice_name = File.basename(RAILS_ROOT).singularize.downcase
      @slice_class = slice_name.classify
      slice_dir = "lib/eschaton_slices/#{slice_name}"

      m.directory slice_dir

      m.template "generator_ext.rb", "#{slice_dir}/#{slice_name}_generator_ext.rb" 
      m.template "view_ext.rb", "#{slice_dir}/#{slice_name}_view_ext.rb"
    end
  end

end