module Google

  # Provides a base for all google map objects. Handles map object events in a general manner with the use of listen_to.
  class MapObject < JavascriptObject

    def initialize(options)
      super
    end

    # Listens for events on a map object.
    # 
    # * +event+ - Required. The event that should be listened to.
    # * +on+ - Optional. The object on which the event occurs, defaulted to +JavascriptObject#var+
    # * +with+ - Optional. Arguments that are passed along when the event is fired, these will also be yielded to the supplied block.
    # * +yield_order+ - Optional. The order in which the +with+ options should be yielded to the ruby block.
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
    def listen_to(options = {}, &block) # :yields: script + :with or :yield_order option
      event = Event.new :on => self.var, :event => options.extract_and_remove(:event)
      event.listen_to options, &block
      
      event
    end
    
    # Removes the map object from the map canvas
    def remove!
      self.script << "map.removeOverlay(#{self})"
    end

    protected    
      def options_to_fields(options)
        string_hash = options.stringify_keys
        string_hash.keys.sort.each do |key|
          method, value = "#{key}=", string_hash[key]
          self.send(method, value) if value.not_blank? && self.respond_to?(method)
        end
      end

  end

end
