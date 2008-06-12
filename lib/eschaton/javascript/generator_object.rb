module GeneratorObject
  attr_accessor :context
  
  def setup_generator(options)
    self.context = options.extract_and_remove(:context) if options[:context]
  end
  
  # Yields a new script proxy to the block and returns the generated output of that script proxy
  def return_script
    script = ScriptProxy.new
    yield script
    
    script.to_s
  end
  
  def to_s
    @script.to_s
  end

  protected
    def script
      @script ||= ScriptProxy.new
    end

end