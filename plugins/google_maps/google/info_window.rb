module Google
  
  class InfoWindow < MapObject

    def initialize(options = {})
      super
    end

    def open(options)
      content = window_content options[:content]
      self << "#{self.var}.openInfoWindow(#{options[:location]}, #{content});"
    end
    
    def open_on_marker(options)
      content = window_content options[:content]
      self << "#{self.var}.openInfoWindow(#{content});"
    end
    
    private
      def window_content(content)
        "\"<div id='info_window_content'>\" + #{content.to_js} + \"</div>\""
      end

  end
end