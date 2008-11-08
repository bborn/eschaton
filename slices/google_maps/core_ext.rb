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

end

class Symbol # :nodoc:
  
  def to_google_control
    "G#{self.to_s.classify}Control".to_sym
  end

  def to_map_type
    "G_#{self.to_s.upcase}_MAP".to_sym
  end
  
  def to_google_anchor
    "G_ANCHOR_#{self.to_s.upcase}".to_sym
  end
    
end

class Hash # :nodoc:

  # ==== Options
  # * +dont_convert+ - An array of keys that should *_not_* be converted to javascript.
  def to_google_options(options = {})
    dont_convert = (options[:dont_convert] || []).collect(&:to_s)
    string_keys = self.stringify_keys

    args = string_keys.keys.sort.collect do |key|
             value = if key.in?(dont_convert)
                       string_keys[key]
                     else
                       string_keys[key].to_js
                     end

             "#{key.to_js_method}: #{value}"
           end

    "{#{args.join(', ')}}"
  end
  
end
