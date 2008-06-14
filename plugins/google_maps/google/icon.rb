module Google
  class Icon < MapObject
  
    # :image, :size, :anchor, :info_window_anchor
    def initialize(options = {})
      options.default! :var => 'icon'
            
      super
      
      options.assert_valid_keys :image, :size, :anchor, :info_window_anchor
      
      options.default! :size => '24x24', :anchor => '24x24',
                       :info_window_anchor => '24x24'
            
      script << "#{self.var} = new GIcon();"
    
      options_to_fields options
    end
  
    def image=(image)
      image = "/images/#{image}.png" if image.is_a?(Symbol)
      
      script << "icon.image = '#{image}';"
    end
  
    def size=(size)
      width, height = parse_dimentions(size)
      script << "icon.iconSize = new GSize(#{width}, #{height});"
    end
  
    def anchor=(point)
      width, height = parse_dimentions(point)
      script << "icon.iconAnchor = new GPoint(#{width}, #{height});"
    end
  
    def info_window_anchor=(point)
      width, height = parse_dimentions(point)
      script << "icon.infoWindowAnchor = new GPoint(#{width}, #{height});"
    end  
    
    # This method provides compatibility with Symbol#to_icon and String#to_icon and in this case returns self.
    def to_icon
      self
    end
    
    private
      # Returns height and width from the given +size+. The size is in the format of 'WxH' i.e 16x16, 20x24
      def parse_dimentions(size)
        match = size.match /(\d+)x(\d+)/
        return match.group(1).to_i, match.group(2).to_i
      end
  end
end