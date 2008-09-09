module Google
  
  class Event < MapObject
    attr_reader :on, :event

    def initialize(options = {})
      options.default! :var => "#{options[:on]}_#{options[:event]}_event"

      options.assert_valid_keys :var, :on, :event

      super

      @on = options[:on]
      @event = options[:event]
    end
    
    def listen_to(options = {})
      options.default! :with => []
      options.assert_valid_keys :with, :yield_order

      with_arguments = options[:with].arify
      js_arguments = with_arguments.join(', ')

      yield_args = if options[:yield_order]
                     options[:yield_order]
                   else
                     with_arguments
                   end

      # Wrap the GEvent closure in a method to prevent the non-closure bug of javascript and google maps.
      wrap_method = "#{self.on}_#{self.event}(#{self.on})"

      self << "function #{wrap_method}{"
      self << "return GEvent.addListener(#{self.on}, \"#{self.event}\", function(#{js_arguments}) {"

      yield *(self.script.arify + yield_args)

      self <<  "});"
      self << "}"

      script << "#{self.var} = #{wrap_method};"
    end    

    def remove
      self << "GEvent.removeListener(#{self.var});"
    end

  end

end