module Google
  
  # see http://code.google.com/apis/maps/documentation/reference.html#GPolyline
  class Line < MapObject

    # :points
    def initialize(options = {})
      options.default! :var => 'line'

      super
      
      if create_var?
        points = options[:points].collect(&:to_location)
                
        self << "#{self.var} = new GPolyline(#{points.to_js});"
      end
    end
 
  end
end