class Hash # :nodoc:
  alias extract delete  
    
  # Defaults key values in a hash that are not present. Works like #merge but does not overwrite
  # existing keys. This is usefull when using options arguments.
  def default!(options = {})
    options.each do |key, value|      
      self[key] = value if self[key].nil?
    end
    
    self
  end

end
