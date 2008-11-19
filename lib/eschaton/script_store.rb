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

end