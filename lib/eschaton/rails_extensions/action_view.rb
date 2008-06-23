class ActionView::Base

  # Extends the ActionView::Base by including the +extention_module+.
  def self.extend_with_plugin(extention_module)
    include extention_module
  end

end