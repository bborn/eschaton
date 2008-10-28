module Google
  
  # Provides translation to the relevant Google mapping object when working with method options.
  class OptionsHelper # :nodoc:

    def self.to_content(options)
      if options[:partial]
        Eschaton.current_view.render options
      elsif options[:javascript]
        Eschaton.global_script << "var javascript = #{options[:javascript]};"

        :javascript
      else
        options[:text]
      end
    end
    
    def self.to_polygon(options)
      if options.is_a?(Google::Polygon)
        options
      else
        Google::Polygon.new options
      end
    end
    
    def self.to_circle(options)
      if options.is_a?(Google::Circle)
        options
      else
        Google::Circle.new options
      end
    end
    
    def self.to_icon(options)
      if options.is_a?(Google::Icon)
        options
      elsif options.is_a?(String) || options.is_a?(Symbol)
        Google::Icon.new :image => options        
      else
        Google::Icon.new options
      end
    end
    
    def self.to_location(options)
      if options.is_a?(Google::Location) || options.is_a?(Symbol) || options.is_a?(String)
        options
      elsif options.is_a?(Array)
        Google::Location.new :latitude => options.first, :longitude => options.second        
      elsif options.is_a?(Hash)
        Google::Location.new options
      end
    end
    
    def self.to_marker(options)
      if options.is_a?(Hash)
        Google::Marker.new options
      elsif options.is_a?(Symbol)
        Google::Marker.existing :var => options
      else
        options
      end
    end
    
    def self.to_line(options)
      if options.is_a?(Hash)
        Google::Line.new options
      else
        options
      end
    end

    def self.to_image(image)
      if image.is_a?(Symbol)
        "/images/#{image}.png"        
      elsif image.is_a?(String)
        image
      end
    end

    def self.to_gravatar_icon(options)
      if options.is_a?(String)
        Google::GravatarIcon.new :email_address => options
      elsif options.is_a?(Hash)
        Google::GravatarIcon.new options
      end
    end

  end

end