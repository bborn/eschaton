class PluginLoader
  
  # Loads all plugins found using plugin_locations and extends relevent objects.
  def self.load
    self.plugin_locations.each do |plugin_location|
      mixin_plugin_extentions plugin_location
    end
  end
  
  # Returns all the locations in which eschaton plugins are located.
  def self.plugin_locations
    locations = []
    locations << "#{File.dirname(__FILE__)}/../../plugins"
    locations << "#{RAILS_ROOT}/lib/eschaton_plugins"
    
    locations.collect{|location|    
      Dir["#{location}/*"]
    }.flatten
  end
  
  private
    def self.mixin_plugin_extentions(location)
      _logger_info "loading plugin '#{File.basename(location)}'"
       
      Dependencies.load_paths << location
      Dir["#{location}/*.rb"].each do |file|
        Dependencies.require_or_load file
      end
      
      # Generator extentions
      mixin_extentions :path => "#{location}/*_generator_ext.rb",
                       :regexp => /([a-z_]*_generator_ext).rb/,
                       :module_to_extend => ActionView::Helpers::PrototypeHelper::JavaScriptGenerator

      # View extentions
      mixin_extentions :path => "#{location}/*_view_ext.rb",
                       :regexp => /([a-z_]*_view_ext).rb/,
                       :module_to_extend => ActionView::Base
    end
    
    def self.mixin_extentions(options)
      Dir[options[:path]].each do |file|
        module_name = options[:regexp].match(file).group(0)
        options[:module_to_extend].extend_with_plugin module_name.camelize.constantize
      end
    end
    
      
end