module Google
  
  # see http://code.google.com/apis/maps/documentation/reference.html#GMarker
  class Marker < MapObject
  
    # :location, :icon
    def initialize(options = {})
      options.default! :variable => 'marker'
      
      super
      
      options.assert_valid_keys :location, :icon

      if create_variable?
        location = options[:location]
        location = location.to_location if location.is_a?(Hash)
      
        icon = options[:icon]
        if icon
          icon = Icon.new(:image => icon) if icon.is_a?(Symbol)
      
          script << icon
          script << "#{self.variable} = new GMarker(#{location}, icon);"
        else
          script << "#{self.variable} = new GMarker(#{location});"
        end
      end
    end
    
    def change_icon(image)
      "#{self.variable}.setImage('#{image}')"
    end
    
    def click(&block)
      self.listen_to :click, :on => self.variable, &block
    end
    
  end
end