module Google
  
  # Represents a map. If a method or event is not documented here please see googles online[http://code.google.com/apis/maps/documentation/reference.html#GMap2] 
  # docs for details. See MapObject#listen_to on how to use events not listed on this object.
  #
  # You will most likely use click, open_info_window, add_marker and add_markers to get some basic functionality going.
  #
  # ==== Examples:
  #  map = Google::Map.new(:center => {:latitude => -33.947, :longitude => 18.462})
  # 
  #  map = Google::Map.new(:center => {:latitude => -33.947, :longitude => 18.462}, 
  #                        :controls => [:small_map, :map_type])
  #
  #  map = Google::Map.new(:center => {:latitude => -33.947, :longitude => 18.462}, 
  #                        :controls => [:small_map, :map_type],
  #                        :zoom => 12)
  #
  #  map = Google::Map.new(:center => {:latitude => -33.947, :longitude => 18.462}, 
  #                        :controls => [:small_map, :overview_map],
  #                        :zoom => 12, 
  #                        :type => :satellite)
  class Map < MapObject
    attr_reader :center, :zoom, :type
    
    Control_types = [:small_map, :large_map, :small_zoom, 
                     :scale, 
                     :map_type, :menu_map_type, :hierarchical_map_type,
                     :overview_map]
    Map_types = [:normal, :satellite, :hybrid]

    # ==== Options: 
    # * +center+ - Optional. Centers the map at this location, see center=.
    # * +controls+ - Optional. Which controls will be added to the map, see Control_types for valid controls.
    # * +zoom+ - Optional. The zoom level of the map defaulted to 6, see zoom=.
    # * +type+ - Optional. The type of map, see type=.
    def initialize(options = {})
      options.default! :var => 'map', :zoom => 6

      super

      options.assert_valid_keys :center, :controls, :zoom, :type

      if self.create_var?
        script << "#{self.var} = new GMap2(document.getElementById('#{self.var}'));" 
        
        self.center = options.extract_and_remove(:center)
        self.zoom = options.extract_and_remove(:zoom) if options[:zoom]

        self.options_to_fields options
      end
    end

    # Sets the type of map to display, see Map_types of valid map types.
    def type=(value)
      @type = value
      self << "#{self.var}.setMapType(#{value.to_map_type})"
    end
    
    # Centers the map at the given +location+ which can be a Location or whatever Location#new supports.
    #
    # ==== Examples:
    #  map.center = {:latitude => -34, :longitude => 18.5}
    #
    #  map.center = Google::Location.new(:latitude => -34, :longitude => 18.5)
    def center=(location)
      @center = location.to_location

      self.set_center(self.center)
    end
    
    # Sets the zoom level of the map.
    def zoom=(zoom)
      @zoom = zoom

      self.set_zoom(self.zoom)
    end

    # Adds the +control+ to the map, see Control_types of valid controls.
    #
    # ==== Options:
    # * +position+ - Optional. The position that the control should be placed.
    #
    # ==== Examples:
    #  add_control :small_zoom
    #  add_control Google::Pane.new(:text => 'This is a pane')
    #  add_control :small_zoom, :position => {:anchor => :top_right}
    #  add_control :map_type, :position => {:anchor => :top_left}
    #  add_control :map_type, :position => {:anchor => :top_left, :offset => [10, 10]}
    def add_control(control, options = {})
      control = "new #{control.to_google_control}()" if control.is_a?(Symbol)
      position = options[:position].to_google_position if options[:position]
      arguments = [control, position].compact

      script << "#{self.var}.addControl(#{arguments.join(', ')});"
    end

    # Adds a control or controls to the map, see Control_types of valid controls.
    # The controls will all be placed at their default positions, if you need control over the position use add_control.   
    #
    # ==== Examples:
    #  controls = :small_zoom
    #  controls = :small_zoom, :map_type
    #  controls = :small_zoom, Google::Pane.new(:text => 'This is a pane')    
    def controls=(*controls)
      controls.flatten.each do |control|
        self.add_control control
      end
    end
    
    # Replaces an existing marker on the map
    def replace_marker(marker_or_options)
      remove_marker marker_or_options
      add_marker marker_or_options
    end

    # Adds a single marker to the map which can be a Marker or whatever Marker#new supports.     
    def add_marker(marker_or_options)
      marker = marker_or_options.to_marker
      self.add_overlay marker

      marker      
    end

    # Adds markers to the map. Each marker in +markers+ can be a Marker or whatever Marker#new supports.
    def add_markers(*markers_or_options)
      markers_or_options.flatten.collect do |marker_or_options|
        add_marker marker_or_options
      end
    end
    
    # Removes marker that has already been placed on the map
    def remove_marker(marker_or_options)
      # TODO - Refactor out!
      marker_id = if marker_or_options.is_a?(Hash)
                    marker_or_options[:var] || :marker
                  else
                    marker_or_options.var.to_sym
                  end

      self.remove_overlay marker_id      
    end
    
    # Adds a +line+ to the map which can be a Line or whatever Line#new supports.
    def add_line(line)
      line = line.to_line
      self.add_overlay line

      line
    end
    
    # Removes the given +overlay+ from the map.
    def remove_overlay(overlay)
      self << "#{self}.removeOverlay(#{overlay.to_sym});"
    end

    # Clears all overlays(info windows, markers, lines etc) from the map.
    def clear
      self.clear_overlays
    end

    # If called with a block it will attach the block to the "click" event of the map.
    # If +info_window_options+ are supplied an info window will be opened with those options and the block will be ignored.
    #
    # This will only run if the map is clicked, not an info window or overlay.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    # * +location+ - The location at which the map was clicked.
    def click(info_window_options = nil)
      if info_window_options
        self.click do |script, location|
          self.open_info_window info_window_options.merge(:location => location)
        end
      elsif block_given?
        self.listen_to :event => :click, :with => [:overlay, :location] do |script, overlay, location|
          script << "if(location){"

          yield script, location

          script << "}"
        end
      end
    end

    def get_location(location) #TODO ? move to Map::Location ?
      if location.is_a?(Symbol)        
        {:latitude => "##{location}.lat()", :longitude => "##{location}.lng()"}
      else
        {:latitude => location.latitude, :longitude => location.longitude}
      end      
    end
      
    # Opens an info window on the map at the given +location+ using either +url+, +partial+ or +text+ options as content.
    #
    # ==== Options:
    # * +location+ - Optional. A Location, whatever Location#new supports or :center which indicates where the info window 
    #   must be placed on the map, defaulted to +center+.
    # * +url+ - Optional. URL is generated by rails #url_for. Supports standard url arguments and javascript variable interpolation.
    # * +include_location+ - Optional. Works in conjunction with the +url+ option and indicates if latitude and longitude parameters of
    #   +location+ should be sent through with the +url+, defaulted to +true+.
    # * +partial+ - Optional. Supports the same form as rails +render+ for partials, content of the rendered partial will be 
    #   placed inside the info window.
    # * +text+ - Optional. The html content that will be placed inside the info window.
    def open_info_window(options)
      #
      # TODO - some of this is sharable between map and marker!!!!!!
      #
      options.default! :location => :center, :include_location => true
      location = options[:location].to_location
      
      self << "center = #{self.var}.getCenter();" if location == :center
      
      if options[:url]
        if options[:include_location] == true
          options[:url][:location] = get_location(location)
        end

        self.script.get(options[:url]) do |data|
          self << "#{self.var}.openInfoWindow(#{location}, #{data});"
        end
      else
        text = if options[:partial]
                 Eschaton.current_view.render options
               else
                 options[:text]
               end
        
        self << "#{self.var}.openInfoWindow(#{location}, #{text.to_js});"
      end
    end

    # Opens an info window at the given +location+ that contains a blowup view of the map around the +location+.
    #
    # ==== Options:
    # * +location+ - Required. The location at which the the blowup must be placed.
    # * +zoom_level+ - Optional. Sets the blowup to a particular zoom level.
    # * +map_type+ - Optional. Set the type of map shown in the blowup.
    def show_blowup(options = {})
      options[:map_type] = options[:map_type].to_map_type if options[:map_type]
      location = options.extract_and_remove(:location).to_location
      
      self << "#{self.var}.showMapBlowup(#{location}, #{options.to_google_options});" 
    end

  end
end
