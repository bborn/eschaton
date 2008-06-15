module Google
  
  class MapObject < JavascriptObject
    
    def initialize(options)
      super
    end
  
    # :with, :on
    # Always yields a script generator + :with args
    def listen_to(event, options = {}, &block)
      options.default! :on => self.var, :with => []            
      options.assert_valid_keys :with, :on    
            
      generator = Eschaton.javascript_generator
      yield *(generator.arify + options[:with])

      js_arguments = options[:with].join(', ')
      self.script << "GEvent.addListener(#{options[:on]}, \"#{event}\", function(#{js_arguments}) {
                       #{generator.generate}
                      });"
    end

    # TODO - Make pretty and move to appropriate place
    def parse_url_for_javascript(url)
      interpolate_symbol, brackets = '%23', '%28%29'
      url.scan(/#{interpolate_symbol}[\w\.#{brackets}]+/).each do |javascript_variable|
        clean = javascript_variable.gsub(interpolate_symbol, '')
        clean.gsub!(brackets, '()')

        url.gsub!(javascript_variable, "' + #{clean} + '")
      end  
      
      url.gsub!('&amp;', '&')
      
      url
    end
    
    protected
      def options_to_fields(options)
        options.each do |key, value|
          method = "#{key}="
          self.send(method, value) if self.respond_to?(method)
        end
      end
  end
  
end

