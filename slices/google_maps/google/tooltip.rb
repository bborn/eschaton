module Google
  
  class Tooltip < MapObject
  
    # ==== Options:
    def initialize(options = {})
      options.default! :var => "tooltip_#{options[:on]}", :show => :on_mouse_hover, :padding => 3
            
      super
      
      on = options[:on]
      content = OptionsHelper.to_content(options)
      show = options[:show]

      script << "#{self} = new Tooltip(#{on}, #{content.to_js}, #{options[:padding]});"                          
      script << "map.addOverlay(#{self});"

      if show == :on_mouse_hover
        on.mouse_over {self.show!}
        on.mouse_off {self.hide!}
      elsif show == :always
        self.show!
      end
    end

    # show + hide

  end
end