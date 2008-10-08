module Google

  class OptionsHelper # :nodoc:

    def self.to_content(options)
      if options[:partial]
        Eschaton.current_view.render options
      elsif options[:javascript]
        Eschaton.global_script << "var javascript = #{options[:javascript]};"

        :javascript
      else
        options[:text]
      end
    end
    
    def self.to_polygon(options)
      if options.is_a?(Google::Polygon)
        options
      else
        Google::Polygon.new options
      end
    end

  end

end