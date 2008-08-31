class Array # :nodoc:

  # Converts the array to a google size[http://code.google.com/apis/maps/documentation/reference.html#GSize]. The +first+ element of the array 
  # represents the +width+ and the +second+ element represents the +height+.
  #
  # ==== Examples:
  #
  #  [10, 10].to_google_size #=> "new GSize(10, 10)"
  #  [100, 50].to_google_size #=> "new GSize(100, 50)"
  #  [200, 150].to_google_size #=> "new GSize(200, 150)"
  def to_google_size
    "new GSize(#{self.first}, #{self.second})"
  end

  def to_location
    Google::Location.new :latitude => self.first, :longitude => self.second
  end

end

class String
  
  def to_icon
    Google::Icon.new :image => self
  end
  
  def to_image
    self
  end
  
  def to_gravatar_icon
    Google::GravatarIcon.new :email_address => self
  end
  
  def to_location
    self
  end
    
end

class Symbol

  def to_icon
    Google::Icon.new :image => self
  end
  
  def to_location
    self
  end

  def to_google_control
    "G#{self.to_s.classify}Control".to_sym
  end

  def to_map_type
    "G_#{self.to_s.upcase}_MAP".to_sym
  end
  
  def to_google_anchor
    "G_ANCHOR_#{self.to_s.upcase}".to_sym
  end
  
  def to_image
    "/images/#{self}.png"
  end
    
end

class Hash

  def to_google_position
    self.default! :offset => [0, 0]

    "new GControlPosition(#{self[:anchor].to_google_anchor}, #{self[:offset].to_google_size})"
  end

  def to_google_options
    string_keys = self.stringify_keys
    args = string_keys.keys.sort.collect do |key|
             "#{key.to_js_method}: #{string_keys[key].to_js}"
           end

    "{#{args.join(', ')}}"
  end
  
  def to_location
    Google::Location.new self
  end

  def to_icon
    Google::Icon.new self
  end

  def to_gravatar_icon
    Google::GravatarIcon.new self
  end
  
  def to_marker
    Google::Marker.new self
  end
  
  def to_line
    Google::Line.new self
  end

end
