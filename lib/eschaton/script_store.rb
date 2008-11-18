module ScriptStore # :nodoc:

  def define(*names)
    names.each do |name|
      self.send(:cattr_accessor, name)
      self.reset_item name

      self.class.send(:define_method, "has_#{name}?") do 
        self.send(name).not_empty?
      end

      self.class.send(:define_method, "clear_#{name}") do
        self.reset_item(name)
      end
    end
  end
  
  # TODO - This assumes we want a string with new lines, refactor
  def reset_item(name)
    existing_value = self.send(name)
    self.send("#{name}=", [])

    existing_value.join("\n") if existing_value
  end

end