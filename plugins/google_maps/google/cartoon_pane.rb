module Google

  class CartoonPane < Pane

    def initialize(text)
      options = {:var => 'cartoon_pane', 
                 :text => "<h3 style='margin: 5px; padding: 5px;'>#{text}</h3>"}

      super options
    end

  end
end
