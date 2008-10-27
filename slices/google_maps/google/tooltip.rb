module Google
  
  class Tooltip < MapObject
    attr_reader :show, :on

    # ==== Options:
    def initialize(options = {})
      options.default! :base_type => options[:on].class.to_s.downcase ,
                       :var => "tooltip_#{options[:on]}", 
                       :padding => 3,
                       :show => :on_mouse_hover

      super

      @show = options[:show]
      @on = options[:on]
      content = OptionsHelper.to_content(options)

      script << "#{self} = new Tooltip(#{options[:base_type].to_js}, #{on}, #{content.to_js}, #{options[:padding]});"
    end

    def update_html(options)
      content = OptionsHelper.to_content(options)
      self << "#{self}.updateHtml(#{content.to_js});"
    end
    
    def force_redraw
      self.redraw true
    end

    def added_to_map(map) # :nodoc:
      map.add_overlay self
      
      if self.show == :always
        self.show!
      elsif self.show == :on_mouse_hover
        on.mouse_over {self.show!}
        on.mouse_off {self.hide!}
      end
    end

    def removed_from_map(map) # :nodoc:
      self.script.if "typeof(#{self}) != 'undefined'" do
        map.remove_overlay self
      end
    end

  end
  
end