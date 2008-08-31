module Google
  
  # Represents a marker that can be added to a Map using Map#add_marker. If a method or event is not documented here please 
  # see googles online[http://code.google.com/apis/maps/documentation/reference.html#GMarker] docs for details. See MapObject#listen_to on how to use
  # events not listed on this object.
  #
  # You will most likely use click, open_info_window and set_tooltip to get some basic functionality going.
  #
  # === General examples:
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5}
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5}, 
  #                     :draggable => true,
  #                     :title => "This is a marker!"
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5},
  #                     :icon => :green_circle #=> "/images/green_circle.png"
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5},
  #                     :icon => '/images/red_dot.gif'
  #
  # === Tooltip examples:
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5},
  #                     :tooltip => {:text => 'This is sparta!'}
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5},
  #                     :tooltip => {:text => 'This is sparta!', :show => :always}
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5},
  #                     :tooltip => {:partial => 'spot_information', :show => :always}
  #
  # === Gravatar examples:
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5},
  #                     :gravatar => 'yawningman@eschaton.com'
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5},
  #                     :gravatar => {:email_address => 'yawningman@eschaton.com', :size => 50}
  #
  # === Circle examples:
  #  Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
  #                     :circle => true
  #
  #  Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
  #                     :circle => {:radius => 500, :border_width => 5}
  #
  # === Info windows using open_info_window:
  #
  #  marker.open_info_window :text => 'Hello there...'
  #
  #  marker.open_info_window :partial => 'spot_information'
  #
  #  marker.open_info_window :partial => 'spot_information', :locals => {:information => information}
  #
  #  map.open_info_window :url => {:controller => :spot, :action => :show, :id => @spot}
  #
  # === Using the click event:
  #  
  #  # Open a info window and circle the marker.
  #  marker.click do |script|
  #    marker.open_info_window :url => {:controller => :spot, :action => :show, :id => @spot}
  #    marker.circle!
  #  end
  class Marker < MapObject
    attr_accessor :icon
    attr_reader :location, :tooltip_var, :circle
    
    # ==== Options:
    # * +location+ - Required. A Location or whatever Location#new supports which indicates where the marker must be placed on the map.
    # * +icon+ - Optional. The Icon that should be used for the marker otherwise the default marker icon will be used.
    # * +gravatar+ - Optional. Uses a gravatar as the icon. If a string is supplied it will be used for the +email_address+ 
    #   option, see Gravatar#new for other valid options.
    # * +circle+ - Optional. Indicates if a circle should be drawn around the marker, also supports styling options(see Circle#new)
    # * +tooltip+ - Optional. Provides the abilty to add a tooltip to the marker, supports the same options as set_tooltip
    #
    # See addtional options[http://code.google.com/apis/maps/documentation/reference.html#GMarkerOptions] that are supported.
    def initialize(options = {})
      options.default! :var => 'marker', :draggable => false

      super

      if create_var?
        @location = options.extract_and_remove(:location).to_location
        #@location = OptionsHandler.to_location!(options) #:extract => true

        self.icon = if icon = options.extract_and_remove(:icon)
                      icon.to_icon
                    elsif gravatar = options.extract_and_remove(:gravatar)
                      gravatar.to_gravatar_icon  
                    end

        options[:icon] = self.icon if self.icon
        
        circle_options = options.extract_and_remove(:circle)
        tooltip_options = options.extract_and_remove(:tooltip)
        
        self << "#{self.var} = new GMarker(#{self.location}, #{options.to_google_options});"

        self.draggable = options[:draggable]
        self.set_tooltip(tooltip_options) if tooltip_options

        if circle_options
          circle_options = {} if circle_options == true
          self.circle! circle_options
        end
      end
    end

    # Opens a information window on the marker using either +url+, +partial+ or +text+ options as content.
    #
    # ==== Options:
    # * +url+ - Optional. URL is generated by rails #url_for. Supports standard url arguments and javascript variable interpolation.
    # * +partial+ - Optional. Supports the same form as rails +render+ for partials, content of the rendered partial will be 
    #   placed inside the info window.
    # * +text+ - Optional. The html content that will be placed inside the info window.
    #
    # ==== Examples:
    #
    #  marker.open_info_window :text => 'Hello there...'
    #
    #  marker.open_info_window :partial => 'spot_information'
    #
    #  marker.open_info_window :partial => 'spot_information', :locals => {:information => information}
    #
    #  map.open_info_window :url => {:controller => :spot, :action => :show, :id => @spot}
    def open_info_window(options)
      info_window = InfoWindow.new(:var => self.var)
      info_window.open_on_marker options
    end

    # If called with a block it will attach the block to the "click" event of the marker.
    # If +info_window_options+ are supplied an info window will be opened with those options and the block will be ignored.
    #
    # ==== Example:
    #
    #  # Open a info window and circle the marker.
    #  marker.click do |script|
    #    marker.open_info_window :url => {:controller => :spot, :action => :show, :id => @spot}
    #    marker.circle!
    #  end
    def click(info_window_options = nil, &block) # :yields: script
      if info_window_options
        self.click do
          self.open_info_window info_window_options
        end
      elsif block_given?
        self.listen_to :event => :click, &block
      end
    end

    # This event is fired when the marker is "picked up" at the beginning of being dragged.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.    
    def when_picked_up(&block)
      self.listen_to :event => :dragstart, &block
    end

    # This event is fired when the marker is being "dragged" across the map.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    # * +current_location+ - The location at which the marker is presently hovering.
    def when_being_dragged
      self.listen_to :event => :drag do
        script << "current_location = #{self.var}.getLatLng();"

        yield script, :current_location
      end
    end

    # This event is fired when the marker is "dropped" after being dragged.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    # * +drop_location+ - The location on the map where the marker was dropped.
    def when_dropped
      self.listen_to :event => :dragend do |script|          
        script << "drop_location = #{self.var}.getLatLng();"

        yield script, :drop_location
      end
    end
   
    # Opens an info window that contains a blown-up view of the map around this marker.
    #
    # ==== Options:
    # * +zoom_level+ - Optional. Sets the blowup to a particular zoom level.
    # * +map_type+ - Optional. Set the type of map shown in the blowup.
    def show_map_blowup(options = {})
     options[:map_type] = options[:map_type].to_map_type if options[:map_type]

     self << "#{self.var}.showMapBlowup(#{options.to_google_options});" 
    end
    
    # Changes the foreground icon of the marker to the given +image+. Note neither the print image nor the shadow image are adjusted.
    #
    #  marker.change_icon :green_cicle #=> "/images/green_circle.png"
    #  marker.change_icon "/images/red_dot.gif"
    def change_icon(image)
      self << "#{self.var}.setImage(#{image.to_image.to_js});"
    end

    # Draws a circle around the marker, see Circle#new for valid styling options.
    #
    # ==== Examples:
    #  marker.circle!
    #
    #  marker.circle! :radius => 500, :border_width => 5
    def circle!(options = {})
      options[:location] = self.location

      @circle = Circle.new options

      if self.draggable?
        self.when_being_dragged do |script, current_location|
          @circle.move_to current_location
        end
      end

      @circle
    end
    
    def circled? # :nodoc:
      @circle.not_nil?
    end

    # Sets the tooltip on the marker using either +text+ or +partial+ options as content. The tooltip window will 
    # float just above the marker.
    #
    # To style the tooltip define a 'tooltip' style in your CSS stylesheet.
    # The tooltip can then be shown or hidden by using show_tooltip! and hide_tooltip!. 
    #
    # ==== Options:
    # * +text+ - Optional. The text to display in the tooltip.
    # * +partial+ - Optional. Supports the same form as rails +render+ for partials, content of the rendered partial will be
    #   displayed in the tooltip.
    # * +show+ - Optional. If set to +always+ the tooltip will always be visible. If set to +on_mouse_hover+ the 
    #   tooltip will only be shown when the cursor 'hovers' over the maker. If you wish to use your own way of showing
    #   the tooltip set this to +false+, defaulted to +on_mouse_hover+.
    #
    # ==== Examples:
    #  # By default will show when mouse 'hovers' over marker
    #  marker.set_tooltip :text => "This is sparta!"
    #
    #  # Explicitly indicate that on_mouse_hover used
    #  marker.set_tooltip :text => "This is sparta!", :show => :on_mouse_hover
    #
    #  marker.set_tooltip :text => "This is sparta!", :show => :always
    #
    #  # Open the tool tip yourself at a later stage
    #  marker.set_tooltip :text => "This is sparta!", :show => false
    #
    #  marker.set_tooltip :partial => 'spot_information'
    #
    #  marker.set_tooltip :partial => 'spot_information', :locals => {:information => information},
    #                     :show => :always
    def set_tooltip(options)
      options.default! :show => :on_mouse_hover, :padding => 3

      show = options.extract_and_remove(:show)
      content = OptionsHelper.to_content options

      @tooltip_var = "tooltip#{self}"

      script << "#{self.tooltip_var} = new Tooltip(#{self}, #{content.to_js}, #{options[:padding]});"                          
      script << "map.addOverlay(#{self.tooltip_var});"

      if show == :on_mouse_hover
        self.mouse_over {self.show_tooltip!}
        self.mouse_off {self.hide_tooltip!}
      elsif show == :always
        self.show_tooltip!
      end
      
      if self.draggable?
        self.when_picked_up do |script|
          script << "#{self.tooltip_var}.markerPickedUp();"
        end

        self.when_dropped do |script, location|
          script << "#{self.tooltip_var}.markerDropped();"
        end

        self.when_being_dragged do
          self.redraw_tooltip!
        end
      end
    end
    
    # Updates the tooltip on the marker with the given +options+. Supports the same +options+ as set_tooltip.
    def update_tooltip(options)
      if self.has_tooltip?
        content = OptionsHelper.to_content options
        self << "#{self.tooltip_var}.updateHtml(#{content.to_js});"
      else
        self.set_tooltip options
      end
    end

    def has_tooltip? # :nodoc:
      @tooltip_var.not_nil?
    end
    
    # Shows the tooltip just above the marker.
    def show_tooltip!
      self << "#{self.tooltip_var}.show();"
    end

    # Hides the tooltip if it is visible.
    def hide_tooltip!
      self << "#{self.tooltip_var}.hide();"
    end
    
    def draggable=(value) # :nodoc:
      @draggable = value

      if self.draggable?
        self.when_picked_up{ self.close_info_window }
      end
    end

    def draggable? # :nodoc:
      @draggable
    end
    
    # This event is fired when the mouse "moves over" the marker.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    def mouse_over(&block)
      self.listen_to :event => :mouseover, &block
    end

    # This event is fired when the mouse "moves off" the marker.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    def mouse_off(&block)
      self.listen_to :event => :mouseout, &block
    end

    # Moves the marker to the given +location+ on the map.
    def move_to(location)
      @location = location.to_location

      self.lat_lng = @location

      self.redraw_tooltip! if self.has_tooltip?
      self.circle.move_to @location if self.circled?
    end

    def to_marker # :nodoc:
      self
    end
    
    protected
      def redraw_tooltip!
        self << "#{self.tooltip_var}.redraw(true);"        
      end
  
  end
end