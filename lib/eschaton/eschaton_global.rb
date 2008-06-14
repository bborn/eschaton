#  Provides access to global objects of interest.
class EschatonGlobal
  cattr_accessor :current_controller, :current_view
  
  def self.url_for(options)
    self.current_view.url_for(options)
  end
  
  def self.javascript_generator(&block)
    self.current_view.javascript(&block)
  end
  
end