module Google
  
  class Pane < MapObject

    # :style, :text
    #
    def initialize(options = {})
      options.default! :var => 'pane', :style => {}
      
      style = options[:style]
      style.default! :width => :auto, :height => :auto, :background_color => "#fff",
                     :border => "1px solid gray", :opacity => 1

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
          return new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10));
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