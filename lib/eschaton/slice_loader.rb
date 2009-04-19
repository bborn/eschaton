class SliceLoader # :nodoc:
  
  # Loads all slices found using slice_locations and extends relevant objects.
  def self.load
    self.slice_locations.each do |slice_location|
      mixin_slice_extentions slice_location
    end
  end

  private  
    # Returns all the locations in which eschaton slices are located.
    def self.slice_locations
      locations = []
      locations << "#{File.dirname(__FILE__)}/../../slices"
      locations << "#{RAILS_ROOT}/lib/eschaton_slices"

      locations.collect{|location|
        Dir["#{location}/*"]
      }.flatten
    end
    
    def self.mixin_slice_extentions(location)
      _logger_info "loading slice '#{File.basename(location)}'"
       
      Eschaton.dependencies.load_paths << location
      Dir["#{location}/*.rb"].each do |file|
        # require file, for some reason
        Eschaton.dependencies.require file
      end

      # Generator extentions
      mixin_extentions :path => location, :pattern => /([a-z_\d]*_generator_ext).rb/,
                       :extend => ActionView::Helpers::PrototypeHelper::JavaScriptGenerator

      # View extentions
      mixin_extentions :path => location, :pattern => /([a-z_\d]*_view_ext).rb/,
                       :extend => ActionView::Base

      # Controller extentions
      mixin_extentions :path => location, :pattern => /([a-z_\d]*_controller_ext).rb/,
                       :extend => ActionController::Base                       
    end

    def self.mixin_extentions(options)      
      Dir["#{options[:path]}/*.rb"].each do |file|
        if module_name = options[:pattern].match(file)
          options[:extend].extend_with_slice module_name[1].camelize.constantize
        end
      end
    end

end