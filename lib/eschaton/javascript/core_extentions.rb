class Object
  
  def to_js
    if self.is_a?(Symbol)
      self
    else
      self.to_json
    end
  end

end

class String
  
  # Returns the lower camelCase format
  #  'zoom=' #=> 'setZoom'
  #  'set_zoom' #=> 'setZoom'
  #  'open_info_window' #=> 'openInfoWindow'
  def lowerCamelize
    camel_case = if self =~ /=$/ 
                   "set_#{self.chop}"
                 else
                   self
                 end

    camel_case.camelize.gsub(/\b\w/){$&.downcase}
  end
  
end

class Array
  
  # Returns an argument list that can be used when calling a javascript method.
  # Arguments will be converted to there javascript equivalents and seperated by a commas.
  #  [1, 2] #=> 1, 2
  #  [1.5, "Hello"] #=> 1.5, "Hello"
  #  [[1, 2], "Goodbye"] #= > [1, 2], "Goodbye"
  def to_js_arguments
    self.collect(&:to_js).join(', ')
  end
    
end