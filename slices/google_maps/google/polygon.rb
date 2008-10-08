module Google

  # Represents a polygon that can be added to a Map using Map#add_polygon. If a method or event is not documented here please 
  # see googles online[http://code.google.com/apis/maps/documentation/reference.html#GPolygon] docs for details.
  # See MapObject#listen_to on how to use events not listed on this object.
  class Polygon < MapObject
    attr_reader :vertices

    # ==== Options:
    # * +vertices+ - Required. A single location or array of locations representing the vertices of the polygon.
    # * +editable+ - Optional. Indicates if the polygon is editable, defaulted to +false+.
    #
    # ==== Styling options
    # * +border_colour+ - Optional. The colour of the border, can be a name('red', 'blue') or a hex colour, defaulted to '#00F'
    # * +border_thickness+ - Optional. The thickness of the border in pixels, defaulted to 2.
    # * +border_opacity+ - Optional. The opacity of the border between 0 and 1, defaulted to 0.5.
    # * +fill_colour+ - Optional. The colour that the circle is filled with, defaulted to '##66F'.
    # * +fill_opacity+ - Optional. The opacity of the filled area of the circle, defaulted to 0.5.
    def initialize(options = {})
      options.default! :var => 'polygon', :vertices => [],
                       :editable => false,
                       :border_colour => '#00F',
                       :border_thickness => 2,
                       :border_opacity => 0.5,
                       :fill_colour => '#66F',
                       :fill_opacity => 0.5               

      super

      if create_var?
        self.vertices = options.extract(:vertices).arify.collect(&:to_location)
        editable = options.extract(:editable)
        
        border_colour =  options.extract(:border_colour) 
        border_thickness =  options.extract(:border_thickness) 
        border_opacity =  options.extract(:border_opacity)

        fill_colour = options.extract(:fill_colour)
        fill_opacity = options.extract(:fill_opacity)
        
        remaining_options = options
        self << "#{self.var} = new GPolygon([#{self.vertices.join(', ')}], #{border_colour.to_js}, #{border_thickness.to_js}, #{border_opacity.to_js}, #{fill_colour.to_js}, #{fill_opacity.to_js}, #{remaining_options.to_google_options});"

        self.enable_editing! if editable
      end
      
    end

    # Adds a vertex at the given +location+ and updates the shape of the polygon.
    def add_vertex(location)
      self << "#{self.var}.insertVertex(#{self.last_vertex_index}, #{location.to_location})"
    end
    
    def click(&block)
      self.listen_to :event => :click, :with => :location, &block
    end

    def last_vertex_index
      "#{self.vertext_count} - 1"
    end
    
    def vertex_count
      "#{self.var}.getVertexCount()"
    end
    
    protected
      attr_writer :vertices

  end
end
