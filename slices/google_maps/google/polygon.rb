module Google

  # Represents a polygon that can be added to a Map using Map#add_polygon. If a method or event is not documented here please 
  # see googles online[http://code.google.com/apis/maps/documentation/reference.html#GPolygon] docs for details.
  # See MapObject#listen_to on how to use events not listed on this object.
  class Polygon < MapObject
    attr_reader :vertices
    
    include Tooltipable
    
    # ==== Options:
    # * +vertices+ - Required. A single location or array of locations representing the vertices of the polygon.
    # * +editable+ - Optional. Indicates if the polygon is editable, defaulted to +false+.
    # * +tooltip+ - Optional. See Google::Tooltip#new for valid options.    
    #
    # ==== Styling options
    # * +border_colour+ - Optional. The colour of the border, can be a name('red', 'blue') or a hex colour, defaulted to '#00F'
    # * +border_thickness+ - Optional. The thickness of the border in pixels, defaulted to 2.
    # * +border_opacity+ - Optional. The opacity of the border between 0 and 1, defaulted to 0.5.
    # * +fill_colour+ - Optional. The colour that the circle is filled with, defaulted to '#66F'.
    # * +fill_opacity+ - Optional. The opacity of the filled area of the circle, defaulted to 0.5.
    def initialize(options = {})
      options.default! :var => 'polygon', :vertices => [],
                       :editable => false,
                       :border_colour => '#00F',
                       :border_thickness => 2,
                       :border_opacity => 0.5,
                       :fill_colour => '#66F',
                       :fill_opacity => 0.5,
                       :from_encoded => false               

      super

      if create_var?
        from_encoded  = options.extract(:from_encoded)
        
        unless from_encoded
          self.vertices = options.extract(:vertices).arify.collect do |vertex|
            Google::OptionsHelper.to_location(vertex)
          end
        else
          self.vertices = options.extract(:vertices)
        end

        
        editable = options.extract(:editable)
        
        border_colour =  options.extract(:border_colour) 
        border_thickness =  options.extract(:border_thickness) 
        border_opacity =  options.extract(:border_opacity)

        fill_colour = options.extract(:fill_colour)
        fill_opacity = options.extract(:fill_opacity)
        
        tooltip_options = options.extract(:tooltip)
        
        remaining_options = options
        
        unless from_encoded
          self << "#{self.var} = new GPolygon([#{self.vertices.join(', ')}], #{border_colour.to_js}, #{border_thickness.to_js}, #{border_opacity.to_js}, #{fill_colour.to_js}, #{fill_opacity.to_js}, #{remaining_options.to_google_options});"
        else
          polylines = "[{points: \"#{self.vertices[:points]}\", levels: \"#{self.vertices[:levels]}\", numLevels: #{self.vertices[:numLevels]}, zoomFactor: #{self.vertices[:zoomFactor]}, color: #{border_colour.to_js}, weight: #{border_thickness.to_js}, opacity: #{border_opacity.to_js}}]"
                          
          self << "#{self.var} = new GPolygon.fromEncoded({polylines: #{polylines}, fill: true, color: #{fill_colour.to_js}, outline: true, opacity:#{fill_opacity.to_js}});"
                
        end

        self.enable_editing! if editable
        self.set_tooltip(tooltip_options) if tooltip_options
      end
    end
    
    def self.new_from_encoded(options = {})
      options.default! :from_encoded => true
      new(options)
    end

    # Adds a vertex at the given +location+ and updates the shape of the polygon.
    def add_vertex(location)
      location = Google::OptionsHelper.to_location(location)
      self << "#{self.var}.insertVertex(#{self.last_vertex_index}, #{location})"
    end
    
    def click(&block)
      self.listen_to :event => :click, :with => :location, &block
    end

    # This event is fired when the mouse "moves over" the polygon.
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

    # This event is fired when the mouse "moves off" the polygon.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    def mouse_off(&block)
      self.listen_to :event => :mouseout, &block
    end

    # This event is fired when the polygon has been edited.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    def edited(&block)
      self.listen_to :event => :lineupdated, &block
    end

    def last_vertex_index
      "#{self.vertext_count} - 1"
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
    
    protected
      attr_writer :vertices

  end
end
