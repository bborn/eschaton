module Google

  # Represents a polyline that can be added to a Map using Map#add_line. If a method or event is not documented here please 
  # see googles online[http://code.google.com/apis/maps/documentation/reference.html#GPolyline] docs for details.
  # See MapObject#listen_to on how to use events not listed on this object.
  #
  # === Examples:
  #
  #  Google::Line.new :vertices => [{:latitude => -33.958, :longitude => 18.462},
  #                                 {:latitude => -33.987, :longitude => 18.462},
  #                                 {:latitude => -33.999, :longitude => 18.472}]
  #
  #  Google::Line.new :from => {:latitude => -33.958, :longitude => 18.462},
  #                   :to => {:latitude => -33.987, :longitude => 18.462}
  #
  #  Google::Line.new :from => {:latitude => -33.958, :longitude => 18.462},
  #                   :to => {:latitude => -33.987, :longitude => 18.462},
  #                   :colour => 'red', :thickness => 20
  #
  #  # Adding a line betweem markers
  #  markers = map.add_markers({:location => {:latitude => -33.958, :longitude => 18.462}},
  #                            {:location => {:latitude => -33.987, :longitude => 18.462}},
  #                            {:location => {:latitude => -33.999, :longitude => 18.472}})
  #
  #  Google::Line.new :between_markers => markers, :colour => 'red', :thickness => 10
  #
  # === Encoding examples:
  #
  #  # Encoded line with default styling
  #  Google::Line.new :encoded => {:points => 'ihglFxjiuMkAeSzMkHbJxMqFfQaOoB', :levels => 'PFHFGP',
  #                                :num_levels => 18, :zoom_factor => 2}
  #
  #  # Encoded line with styling
  #  Google::Line.new :encoded => {:points => 'ihglFxjiuMkAeSzMkHbJxMqFfQaOoB', :levels => 'PFHFGP',
  #                                :num_levels => 18, :zoom_factor => 2},
  #                   :colour => 'green', :opacity => 1, :thickness => 10
  #
  class Line < MapObject
    attr_reader :vertices, :encoded
    
    include Tooltipable
    
    # Either +vertices+, +from+ and +to+, +between_markers+ or +encoded+ will be used to draw the line.
    #
    # ==== Options:
    # * +vertices+ - Optional. A single location or array of locations representing the vertices of the line.
    # * +from+ - Optional. The location where the line begins.
    # * +to+ - Optional. The location where the line ends.
    # * +between_markers+ - Optional. An array of markers. The line will be drawn between the markers.
    #
    # * +editable+ - Optional. Indicates if the line is editable, defaulted to +false+.    
    # * +tooltip+ - Optional. See Google::Tooltip#new for valid options.
    #    
    # ==== Encoded options
    # * +encoded+ - Optional. A single hash or array of hashes witht he below options, which represent encoded polylines.
    #   * +points+ - A string containing the encoded latitude and longitude coordinates.
    #   * +levels+ - A string containing the encoded polyline zoom level groups
    #   * +num_levels+ - The number of zoom levels contained in the encoded +levels+ option.
    #   * +zoom_factor+ - The magnification between adjacent sets of zoom levels in the encoded +levels+ option.    
    #
    # ==== Styling options
    # * +colour+ - Optional. The colour of the line, can be a name('red', 'blue') or a hex colour.
    # * +thickness+ - Optional. The thickness of the line in pixels.
    # * +opacity+ - Optional. The opacity of the line between 0 and 1.
    def initialize(options = {})
      options.default! :var => 'line', :vertices => [], :editable => false

      super

      if create_var?
        self.encoded = options.extract(:encoded)
        
        unless self.encoded?
          options[:vertices] << options.extract(:from) if options[:from]  
          options[:vertices] << options.extract(:to) if options[:to]

          if markers = options[:between_markers]
            markers.each do |marker|
              options[:vertices] << marker.location
            end
          end

          self.vertices = options.extract(:vertices).arify.collect do |vertex| 
                                                                     Google::OptionsHelper.to_location(vertex)
                                                                   end
        end
        
        colour =  options.extract(:colour) 
        thickness =  options.extract(:thickness) 
        opacity =  self.get_opacity(options.extract(:opacity))

        if self.encoded?
          encoded_options = self.encoded.merge(:color => colour, :weight => thickness, :opacity => opacity)
          self << "#{self.var} = new GPolyline.fromEncoded(#{encoded_options.to_google_options});"
        else
          self << "#{self.var} = new GPolyline([#{self.vertices.join(', ')}], #{colour.to_js}, #{thickness.to_js}, #{opacity.to_js});"
        end

        self.enable_editing! if options[:editable] == true

        tooltip_options = options.extract(:tooltip)
        self.set_tooltip(tooltip_options) if tooltip_options
      end
    end

    # Adds a vertex at the given +location+ and updates the shape of the line.
    # +location+ can be a Location or whatever Location#new supports 
    def add_vertex(location)
      location = Google::OptionsHelper.to_location(location)
      self << "#{self.var}.insertVertex(#{self.last_vertex_index}, #{location})"
    end

    # The length of the line along the surface of a spherical earth.
    # The +format+ can be +meters+ or +kilometers+, defaulted to +meters+.
    def length(format = :meters)
      length = "#{self.var}.getLength()"
      length = "#{length} / 1000" if format == :kilometers

      length
    end

    # Changes the style of the line.
    #
    # ==== Options:
    # * +colour+ - Optional. The colour of the line, can be a name('red', 'blue') or a hex colour.
    # * +thickness+ - Optional. The thickness of the line in pixels.
    # * +opacity+ - Optional. The opacity of the line between 0 and 1.
    #
    # ==== Examples:
    #   line.style = {:colour => 'red', :thickness => 12}    
    #   line.style = {:colour => '#aaa', :thickness => 20, :opacity => 1}
    def style=(options)
      stroke_style_options = {}
      stroke_style_options[:color] = options.extract(:colour) if options[:colour]
      stroke_style_options[:weight] = options.extract(:thickness) if options[:thickness]

      stroke_style_options.merge! options
      
      self << "#{self.var}.setStrokeStyle(#{stroke_style_options.to_google_options});"
    end
    
    def click(&block)
      self.listen_to :event => :click, :with => :location, &block
    end
    
    # This event is fired when the mouse "moves over" the line.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    # * +mouse_location+ - The location at which the mouse cursor is hovering within the polygon.
    def mouse_over(&block)
      self.listen_to :event => :mouseover do |script|
        script << "mouse_location = last_mouse_location;"

        yield script, :mouse_location
      end
    end

    # This event is fired when the mouse "moves off" the line.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    def mouse_off(&block)
      self.listen_to :event => :mouseout, &block
    end    
    
    # This event is fired when the line has been edited.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    def edited(&block)
      self.listen_to :event => :lineupdated, &block
    end    

    def last_vertex_index
      "#{self.var}.getVertexCount() - 1"
    end   
    
    def vertex_count
      "#{self.var}.getVertexCount()"
    end    
    
    def added_to_map(map) # :nodoc:
      self.add_tooltip_to_map(map)
    end 

    def removed_from_map(map) # :nodoc:
      self.remove_tooltip_from_map(map)
    end    
    
    # Indicates if the polygon was created using encoded polylines.
    def encoded?
      self.encoded.not_nil?
    end    
    
    protected
      attr_writer :vertices, :encoded
      
      def get_opacity(opacity)
        if opacity == :solid
          1
        else
          opacity
        end
      end

  end
end
