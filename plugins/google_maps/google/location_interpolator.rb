module Google
  
  # Used for interpolating a client side GLocation into a URL.
  class LocationInterpolator < JavascriptObject
    attr_reader :var
   
    def initialize(options = {})
      options.default! :var => 'location'
      
      super
    end

    def latitude
      "##{self}.lat()"
    end

    def longitude
      "##{self.var}.lng()"
    end

  end
end