module Google
  
  # see http://code.google.com/apis/maps/documentation/reference.html#GPolyline
  class Line < MapObject

    #:latlngs,  :color,  weight?
    # points, :color, :thickness
    def initialize(options = {})
      options.default! :var => 'line'

      super
      
      if create_var?
        options[:points] = nil
        arguments = [options[:points], options[:color], options[:thickness]].compact.to_js_arguments

        self << "#{self.var} = new GPolyline([new GLatLng(-34.947, 18.462), new GLatLng(-34.967, 18.562)],#{arguments})"
      end
    end
 
  end
end