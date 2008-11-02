class SliceLoader # :nodoc:
  
  # Loads all slices found using slice_locations and extends relevant objects.
  def self.load(ordered = [])
    self.slice_locations(order).each do |slice_location|
      mixin_slice_extentions slice_location
    end
  end

  # Returns all the locations in which eschaton slices are located.
  def self.slice_locations(ordered = [])
    locations = []
    locations << "#{File.dirname(__FILE__)}/../../slices"
    locations << "#{RAILS_ROOT}/lib/eschaton_slices"

    locations.collect{|location|
      Dir["#{location}/*"]
    }.flatten
  end

  private
    def self.mixin_slice_extentions(location)
      _logger_info "loading slice '#{File.basename(location)}'"
       
      Dependencies.load_paths << location
      Dir["#{location}/*.rb"].each do |file|
        Dependencies.require_or_load file
      end

      # Generator extentions
      mixin_extentions :path => location, :pattern => /([a-z_]*_generator_ext).rb/,
                       :module_to_extend => ActionView::Helpers::PrototypeHelper::JavaScriptGenerator

      # View extentions
      mixin_extentions :path => location, :pattern => /([a-z_]*_view_ext).rb/,
                       :module_to_extend => ActionView::Base
    end

    def self.mixin_extentions(options)      
      Dir["#{options[:path]}/*.rb"].each do |file|
        if module_name = options[:pattern].match(file)
          options[:module_to_extend].extend_with_slice module_name[1].camelize.constantize
        end
      end
    end

end