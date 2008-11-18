class Object
    
  def arify
    if self.is_a?(Array)
      self
    else
      [self]
    end
  end
  
  def not_nil?
    !self.nil?
  end
  
  def not_blank?
    !self.blank?
  end
  
  def assign_field_once(name)
    instance_variable_set("@#{name}", yield) if instance_variable_get("@#{name}").nil?
    instance_variable_get("@#{name}")
  end
  
  def in?(*values)
    values.flatten.include?(self)
  end
    
  def quote
    self.to_s.quote
  end
  
end