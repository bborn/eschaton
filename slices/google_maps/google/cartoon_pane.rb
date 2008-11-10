module Google

  class CartoonPane < Pane

    def initialize(text, options = {})
      options[:text] = "<h3 style='margin: 5px; padding: 5px;'>#{text}</h3>"
      options[:var] ||= 'cartoon_pane'
      options[:css_class] = 'cartoon_pane'
      
      super options
    end

  end
end
