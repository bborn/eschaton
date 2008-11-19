module ScriptStore # :nodoc:

  def define(*names)
    names.each do |name|
      self.send(:cattr_writer, name)

      class_eval "
        def self.#{name}
          @@#{name} ||= ScriptExpander.new

          yield @@#{name} if block_given?

          @@#{name}
        end
      "

      #self.class.send(:define_method, "has_#{name}?") do 
      #  self.send(name).not_empty?
      #end      
      
      #self.reset_item name

      #self.class.send(:define_method, "has_#{name}?") do 
      #  self.send(name).not_empty?
      #end

      #self.class.send(:define_method, "clear_#{name}") do
      #  self.reset_item(name)
      #end
    end
  end

  def clear(*names)
    names.each do |name|
      class_eval "@@#{name} = nil"
    end
  end
  
  def extract(name)
    existing_value = self.send(name)
    self.clear name

    existing_value
  end

  # TODO - This assumes we want a string with new lines, refactor
  #def reset_item(name)
  #  existing_value = self.send(name)
  #  self.send("#{name}=", [])#
  #
  #    existing_value.join("\n") if existing_value
  #  end

end