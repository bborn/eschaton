module Google
  class Icon < MapObject
  
    # :image, :size, :anchor, :info_window_anchor
    def initialize(options = {})
      options.default! :var => 'icon'
            
      super
      
      options.assert_valid_keys :image, :size, :anchor, :info_window_anchor
      
      options.default! :size => '24x24',
                       :anchor => '12x12',
                       :info_window_anchor => '12x12'
            
      script << "#{self.var} = new GIcon();"
    
      options_to_fields options
    end
  
    def image=(image)
      image = "/images/#{image}.png" if image.is_a?(Symbol)
      
      self << "#{self.var}.image = '#{image}';"
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
    
    # This method provides compatibility with Symbol#to_icon and String#to_icon and in this case returns self.
    def to_icon
      self
    end
    
    private
      # Returns height and width from the given +size+. The size is in the format of 'WxH' i.e 16x16, 20x24
      def parse_dimentions(size)
        match = size.match /(\d+)x(\d+)/
        return match.group(0).to_i, match.group(1).to_i
      end
  end
end