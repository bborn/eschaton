module Google
  
  class MapObject < JavascriptObject
    
    def initialize(options)
      super
    end
  
    # Listens for events on the client.
    # 
    # :event:: => Required. The event that should be listened to.
    # :on::  => Optional. The object on which the event occurs, defaulted to +JavascriptObject#var+
    # :with::  => Optional. Arguments that are passed along when the event is fired, these will also be yielded to the supplied block.
    #
    # A JavascriptGenerator along with the +with+ option will be yielded to the block.
    #
    #   map.listen_to :event => :click, :with => [:overlay, :location] do |script, overlay, location|
    #     script.alert('hello')
    #     map.open_info_window(:at => location, :text => 'A window is open!')
    #     # other code that will occur when this event happens...
    #   end
    def listen_to(options = {})
      options.default! :on => self.var, :with => []            
      options.assert_valid_keys :event, :on, :with
      
      with_arguments = options[:with].arify
      js_arguments = with_arguments.join(', ')

      # Wrap the GEvent closure in a method to prevent the non-closure bug of javascript and google maps.
      wrap_method = "#{self.var}_#{options[:event]}(#{self.var})"

      self << "function #{wrap_method}{"
      self << "GEvent.addListener(#{options[:on]}, \"#{options[:event]}\", function(#{js_arguments}) {"

      yield *(self.script.arify + with_arguments)

      self <<  "});"
      self << "}"
      
      script << "#{wrap_method};"
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

