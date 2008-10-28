module Google
  
  # Provides a tooltip that can be applied to any object that includes Google::Tooltipable.
  class Tooltip < MapObject
    attr_reader :show, :on

    # Either +text+ or +partial+ is used as the html for the tooltip.
    #
    # ==== Options:
    # * +text+ - Optional. The text to display in the tooltip.
    # * +partial+ - Optional. Supports the same form as rails +render+ for partials, content of the rendered partial will be
    #   displayed in the tooltip.
    # * +show+ - Optional. If set to +always+ the tooltip will always be visible. If set to +on_mouse_hover+ the 
    #   tooltip will only be shown when the cursor 'hovers' over the maker. If you wish to use your own way of showing
    #   the tooltip set this to +false+, defaulted to +on_mouse_hover+.
    # * +css_class+ - Optional. The css class to use for the tooltip, defaulted to +tooltip+.
    def initialize(options = {})
      options.default! :base_type => options[:on].class.to_s.downcase ,
                       :var => "tooltip_#{options[:on]}", 
                       :padding => 3,
                       :show => :on_mouse_hover,
                       :css_class => 'tooltip'

      super

      @show = options[:show]
      @on = options[:on]
      content = OptionsHelper.to_content(options)

      script << "#{self} = new Tooltip(#{options[:base_type].to_js}, #{on}, #{content.to_js}, #{options[:css_class].to_s.to_js}, #{options[:padding]});"
      
      if self.show == :on_mouse_hover
        on.mouse_over {self.show!}
        on.mouse_off {self.hide!}
      end
    end

    # Updates the tooltip with the given +options+. Either +text+ or +partial+ is used as the html for the tooltip.
    #
    # ==== Options:
    # * +text+ - Optional. The text to display in the tooltip.
    # * +partial+ - Optional. Supports the same form as rails +render+ for partials, content of the rendered partial will be
    #   displayed in the tooltip.    
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
      end
    end

  end
  
end