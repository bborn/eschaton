module Google
  
  class Pane < MapObject

    # :style, :text, :partial
    #
    def initialize(options = {})
      options.default! :var => 'pane', :style => {}, :anchor => :top_left,
                       :position_offset => [10, 10]

      style = options[:style]
      style.default! :width => :auto, :height => :auto, :background_color => "#fff",
                     :border => "1px solid #808080", :opacity => 1

      anchor = options.extract(:anchor).to_google_anchor
      position_offset = options.extract(:position_offset).to_google_size
      
      super
      
      text = if options[:partial]
               Eschaton.current_view.render options
             else
               options[:text]
             end

      if create_var?
        self << "
        function MyPane(){}
        
        MyPane.prototype = new GControl;
        MyPane.prototype.initialize = function(map) {
          var me = this;          
          me.panel = document.createElement('div');
          me.panel.id = '#{self.var}';
          me.panel.style.width = '#{style[:width]}';
          me.panel.style.height = '#{style[:height]}';
          me.panel.style.backgroundColor = '#{style[:background_color]}';
          me.panel.style.border = '#{style[:border]}';
          me.panel.style.opacity = '#{style[:opacity]}';
          
          me.panel.innerHTML = #{text.to_js};

          map.getContainer().appendChild(me.panel);

          return me.panel;
        };

        MyPane.prototype.getDefaultPosition = function() {
          return new GControlPosition(#{anchor}, #{position_offset});
        };

        MyPane.prototype.getPanel = function() {
          return me.panel;
        };
        "
        
        self << "#{self.var} = new MyPane();"
      end
    end

  end
end