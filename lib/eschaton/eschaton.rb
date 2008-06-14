# reset_rjs_debug = ActionView::Base.debug_rjs
# ActionView::Base.debug_rjs = false
#
#  Provides access to global objects of interest.
class Eschaton
  cattr_accessor :current_controller, :current_view
  
  # Generates and returns a relative url using the given +options+.
  def self.url_for(options)
    self.current_view.url_for(options)
  end
  
  # Returns a JavascriptGenerator which is extended by all eschaton plugins.
  def self.javascript_generator
    ActionView::Helpers::PrototypeHelper::JavaScriptGenerator.new(self.current_view){}
  end

end