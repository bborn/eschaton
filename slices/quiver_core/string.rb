class String
  alias pad_left rjust
  
  def quote
    "\"#{self}\""
  end
  
  def unquote
    self.gsub(/^"|"$/, '')
  end
  
  def unquote!
    self.gsub!(/^"|"$/, '')
  end
   
  def safe_constantize(*safe_classes)
    class_name = self.classify
    raise "#{class_name} not deemed safe to constantize" unless safe_classes.empty? || 
                                                                class_name.in?(safe_classes.flatten)

    class_name.constantize
  end

  # Strips leading and trailing whitespace from each line.
  def strip_each_line!
    self.gsub!(/^\s+|\s+$/, '')
  end

  def email_address?
    (self =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i).not_nil?
  end

end