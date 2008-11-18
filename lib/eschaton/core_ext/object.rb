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
  
  def _logger_debug(message)
    RAILS_DEFAULT_LOGGER.debug("eschaton: #{message}") if RAILS_DEFAULT_LOGGER
  end  

  def _logger_info(message)
    RAILS_DEFAULT_LOGGER.info("eschaton: #{message}") if RAILS_DEFAULT_LOGGER
  end

  def _logger_warn(message)
    RAILS_DEFAULT_LOGGER.warn("eschaton: #{message}") if RAILS_DEFAULT_LOGGER
  end  

end