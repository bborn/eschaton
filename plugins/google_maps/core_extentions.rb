class String
  
  def to_icon
    Google::Icon.new(:image => self)
  end
  
end

class Symbol

  def to_icon
    Google::Icon.new(:image => self)
  end
    
end

class Hash
  
  def to_google_options
    args = self.collect do |key, value|
      key = key.to_s.lowerCamelize.to_sym
      "#{key}: #{value.to_js}"
    end
    
    "{#{args.join(', ')}}"
  end
  
  def to_location
    Google::Location.new(:latitude => self[:latitude], :longitude => self[:longitude])
  end
  
  def to_marker
    Google::Marker.new(self)
  end
  
end
