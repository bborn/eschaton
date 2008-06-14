module Google
  
  # see http://code.google.com/apis/maps/documentation/reference.html#GMarker
  class Marker < MapObject
  
    # Options:
    # :location:: => Required. An existing variable(represented by a symbol), Location object or hash which indicates where the marker should be placed.
    # :icon:: => Optional. The Icon that should be used for the marker
    #
    # See addtional options[http://code.google.com/apis/maps/documentation/reference.html#GMarkerOptions] that are supported.
    #
    # Examples:
    #
    #  Google::Marker.new(:location => {:latitude => -34, :longitude => 18.5})
    #
    #  location = Google::Location.new(:latitude => -34, :longitude => 18.5)
    #  Google::Marker.new(:location => location)
    #
    #  Google::Marker.new(:location => :existing_location)
    def initialize(options = {})
      options.default! :var => 'marker'
      
      super
                  
      if create_var?
        location = options.extract_and_remove(:location).to_location

        if icon = options.extract_and_remove(:icon)
          script << icon.to_icon
          options[:icon] = :icon
        end

        script << "#{self.var} = new GMarker(#{location}, #{options.to_google_options});"
      end
    end
    
    def change_icon(image)
      "#{self.var}.setImage('#{image}')"
    end
    
    def click(&block)
      self.listen_to :click, &block
    end
    
    def when_drag_starts(&block)
      self.listen_to :dragstart, &block
    end
    
    def when_drag_ends(&block)
      self.listen_to :dragend, &block
    end

  end
end