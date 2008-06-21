# TODO - Change behaviour of this to use var
module Google

  class Location < MapObject
  
    attr_reader :latitude, :longitude
  
    # :latitude, :longitude
    def initialize(options)
      super
      
      @longitude, @latitude = options[:longitude], options[:latitude]
    end
    
    # This method provides compatibility with Hash#to_location and in this case returns self.
    def to_location
      self
    end
    
    def to_s
      "new GLatLng(#{self.latitude}, #{self.longitude})"
    end
    
    alias to_js to_s
    alias to_json to_s
  end
  
end