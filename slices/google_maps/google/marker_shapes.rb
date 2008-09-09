module Google
  
  # Create shapes using math and markers, this is just for fun!
  class MarkerShapes < MapObject
    
    def initialize(options = {})
    end

    def rose!(location)
      self.each_angle "0.1 * (Math.cos(3*angle));"
    end

    def cardioid!(location)
      self.each_angle "0.05 * (1 - Math.cos(angle));"
    end

    def spiral!(location)
      self.each_angle "0.0005 * angle;"
    end

    def circle!(location)
      self.each_angle "0.05"
    end

    protected
      def each_angle(radius_formula)
        self << "{
          angle = 0;
          i = 1;
          while (angle < 360){
            radius = #{radius_formula}
            x = radius * Math.cos(angle);
            y = radius * Math.sin(angle);  
        "

        marker = Google::Marker.new(:location => {:latitude => 'location.lat() + y', :longitude => 'location.lng() + x'},
                                    :icon => :blue_circle)
        self << "map.addOverlay(marker);"
        
        self << "  
            i = i + 1;
            angle += 5;
          }
         }
        "        
      end
    
  end
  
end