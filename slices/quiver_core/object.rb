class Object
  
  def is_options_hash?
    self.is_a?(Hash)
  end
  
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
  
  def self.cached_attr_reader(name, &block)
    class_eval do 
      define_method(name) do
        assign_field_once(name, &block.bind(self)) #bind the block to self so that it can see (and use) the class instance's binding
      end
    end
  end
  
  def in?(*values)
    values.flatten.include?(self)
  end
  
  def or_minimum_of(min)
    if self <= min
      min
    else
      self
    end
  end
  
  def quote
    self.to_s.quote
  end
  
end