module Google
  
  class MapObject < JavascriptObject
    
    def initialize(options)
      super
    end
  
    # :with, :on, :body
    # If no :body option is supplied, the results of yield will be used
    # Always yields a script generator !!!
    def listen_to(event, options = {}, &block);
      options.assert_valid_keys :with, :on, :body
    
      content = options[:body] || EschatonGlobal.javascript_generator do |script|
                                    args = [script]
                                    args += options[:with] if options[:with]
          
                                    yield *args
                                  end
      
      js_arguments = options[:with].join(', ') if options[:with]      
      self.script << "GEvent.addListener(#{options[:on] || self.var}, \"#{event}\", function(#{js_arguments}) {
                       #{content}
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

