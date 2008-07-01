class MapGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      m.file "jquery.js", "public/javascripts/jquery.js"

      m.file "map_controller.rb", "app/controllers/map_controller.rb"
      m.file "map_helper.rb", "app/helpers/map_helper.rb"

      m.directory "app/views/map"
      m.file "map.erb", "app/views/layouts/map.erb"  
      m.file "index.erb", "app/views/map/index.erb"
    end
  end

end