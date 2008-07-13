module Google

  # Provides a base for all google map objects. Handles map object events in a general manner with the use of listen_to.
  class MapObject < JavascriptObject

    def initialize(options)
      super
    end

    # Listens for events on the client.
    # 
    # :event::       => Required. The event that should be listened to.
    # :on::          => Optional. The object on which the event occurs, defaulted to +JavascriptObject#var+
    # :with::        => Optional. Arguments that are passed along when the event is fired, these will also be yielded to the supplied block.
    # :yield_order:: => Optional. The order in which the +with+ options should be yielded to the ruby block.
    #
    # A JavascriptGenerator along with the +with+ option will be yielded to the block.
    #
    #  Examples:
    #
    #   marker.listen_to :event => :click do
    #     marker.open_info_window :text => "Hello my pretty!"
    #   end
    #
    #   marker.listen_to :event => :click do |script|
    #     script.alert "hello my pretty!"
    #   end
    #    
    #   map.listen_to :event => :click, :with => [:overlay, :location] do |script, overlay, location|
    #     map.add_marker :location => location
    #   end
    #
    #  # Use :yield_order to change order of the block arguments
    #   map.listen_to :event => :click, :with => [:overlay, :location], 
    #                 :yield_order => [:location, :overlay] do |script, location, overlay| # Note the order
    #     map.add_marker :location => location
    #   end
    def listen_to(options = {}) # :yields: script + :with or :yield_order option
      options.default! :on => self.var, :with => []
      options.assert_valid_keys :event, :on, :with, :yield_order
      
      with_arguments = options[:with].arify
      js_arguments = with_arguments.join(', ')
      
      yield_args = if options[:yield_order]
                     options[:yield_order]
                   else
                     with_arguments
                   end

      # Wrap the GEvent closure in a method to prevent the non-closure bug of javascript and google maps.
      wrap_method = "#{self.var}_#{options[:event]}(#{self.var})"

      self << "function #{wrap_method}{"
      self << "GEvent.addListener(#{options[:on]}, \"#{options[:event]}\", function(#{js_arguments}) {"

      yield *(self.script.arify + yield_args)

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
