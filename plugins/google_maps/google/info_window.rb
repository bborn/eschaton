module Google
  
  class InfoWindow < MapObject

    def initialize(options = {})
      super
    end

    def open(options)
      content = "\"<div id='info_window_content'>\" + #{options[:content].to_js} + \"</div>\""
      self << "#{self.var}.openInfoWindow(#{options[:location]}, #{content});"
    end

  end
end