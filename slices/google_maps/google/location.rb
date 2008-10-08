module Google

  class Location < MapObject
    attr_reader :latitude, :longitude
  
    # :latitude, :longitude
    def initialize(options)
      super

      @longitude, @latitude = options[:longitude], options[:latitude]
    end
    
    def to_s
      "new GLatLng(#{self.latitude}, #{self.longitude})"
    end
    
    alias to_js to_s
    def to_json(options = nil)
      to_js
    end
  end

end