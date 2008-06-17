class Object

  def to_js
    if self.is_a?(Symbol)
      self.to_s
    else
      self.to_json
    end
  end

  # Returns the lower camelCase method name.
  #  'zoom=' #=> 'setZoom'
  #  'set_zoom' #=> 'setZoom'
  #  'open_info_window' #=> 'openInfoWindow'  
  def to_js_method
    method_name = self.to_s
    method_name = "set_#{method_name.chop}" if method_name =~ /=$/ 

    method_name.camelize.gsub(/\b\w/){$&.downcase}
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
