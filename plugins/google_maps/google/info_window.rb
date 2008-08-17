module Google
  
  class InfoWindow < MapObject

    def initialize(options = {})
      super
    end

    def open(options)     
      options.default! :location => :center, :include_location => true
      location = options[:location].to_location

      self << "center = #{self.var}.getCenter();" if location == :center      

      if options[:url]
        if options[:include_location] == true
          options[:url][:location] = get_location(location)
        end

        self.script.get(options[:url]) do |data|
          open_info_window_on_map :location => location, :content => data
        end
      else
        text = OptionsHelper.to_content options

        open_info_window_on_map :location => location, :content => text
      end
    end
    
    def open_on_marker(options)
      if options[:url]
        self.script.get(options[:url]) do |data|
          open_info_window_on_marker :content => data
        end
      else
        text = OptionsHelper.to_content options

        open_info_window_on_marker :content => text
      end
    end
    
    def self.build_content(options)
      if options[:url]
        if options[:include_location] == true
          options[:url][:location] = build_location location
        end

        JavascriptObject.global_script.get(options[:url]) do |data|
          yield build_window_content(data)
        end
      else
        text = OptionsHelper.to_content options
        yield build_window_content(text)
      end
    end

    def self.build_location(location)
      if location.is_a?(Symbol) || location.is_a?(String)
        {:latitude => "##{location}.lat()", :longitude => "##{location}.lng()"}
      else
        {:latitude => location.latitude, :longitude => location.longitude}
      end
    end

    def self.build_window_content(content)
      "\"<div id='info_window_content'>\" + #{content.to_js} + \"</div>\""
    end
    
    private
      def window_content(content)
        "\"<div id='info_window_content'>\" + #{content.to_js} + \"</div>\""
      end

      def get_location(location) #TODO ? move to Map::Location ?
        if location.is_a?(Symbol) || location.is_a?(String)
          {:latitude => "##{location}.lat()", :longitude => "##{location}.lng()"}
        else
          {:latitude => location.latitude, :longitude => location.longitude}
        end      
      end

      def open_info_window_on_map(options)
        content = window_content options[:content]
        self << "#{self.var}.openInfoWindow(#{options[:location]}, #{content});"        
      end

      def open_info_window_on_marker(options)
        content = window_content options[:content]
        self << "#{self.var}.openInfoWindow(#{content});"
      end

  end
end