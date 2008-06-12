class PresentationModel
  attr_reader :page, :controller
  
  def initialize(options)
    @page, @controller = options[:page], options[:controller]
  end
  
  def render(*render_options)
    self.controller.render *render_options
  end
  
  def focus_on(element)
    page[element].focus
  end
    
end