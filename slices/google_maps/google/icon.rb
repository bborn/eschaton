module Google
  class Icon < MapObject
  
    # :image, :shadow, :size, :anchor, :info_window_anchor
    def initialize(options = {})
      options.default! :var => 'icon'

      super

      options.default! :anchor => '9x34', :info_window_anchor => '9x2'
            
      script << "#{self.var} = new GIcon();"
    
      options_to_fields options
    end
  
    def image=(image)
      image = Google::OptionsHelper.to_image(image)

      self << "#{self.var}.image = #{image.to_js};"
    end
  
    def shadow=(image)
      image = Google::OptionsHelper.to_image(image)
            
      self << "#{self.var}.shadow = #{image.to_js};"
    end
  
    def size=(size)
      width, height = parse_dimentions(size)
      script << "#{self.var}.iconSize = new GSize(#{width}, #{height});"
    end
  
    def anchor=(point)
      width, height = parse_dimentions(point)
      script << "#{self.var}.iconAnchor = new GPoint(#{width}, #{height});"
    end
  
    def info_window_anchor=(point)
      width, height = parse_dimentions(point)
      script << "#{self.var}.infoWindowAnchor = new GPoint(#{width}, #{height});"
    end  
    
    private
      # Returns height and width from the given +size+. The size is in the format of 'WxH' i.e 16x16, 20x24
      def parse_dimentions(size)
        match = size.match /(\d+)x(\d+)/
        return match.group(0).to_i, match.group(1).to_i
      end

  end
end