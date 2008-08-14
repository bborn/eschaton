class PresentationModel # :nodoc:
  attr_reader :script
  
  def initialize(script)
    @script = script
  end
  
  def focus_on(element)
    self.script[element].focus
  end
    
end