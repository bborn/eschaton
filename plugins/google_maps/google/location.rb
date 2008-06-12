module Google
  class Location < MapObject
  
    attr_reader :latitude, :longitude
  
    # :latitude, :longitude
    def initialize(options)
      super
      
      @longitude, @latitude = options[:longitude], options[:latitude]
    
      script.inline "new GLatLng(#{self.latitude}, #{self.longitude})"
    end
  
  end
end