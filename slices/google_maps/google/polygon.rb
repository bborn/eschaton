module Google

  # Represents a polygon that can be added to a Map using Map#add_polygon. If a method or event is not documented here please 
  # see googles online[http://code.google.com/apis/maps/documentation/reference.html#GPolygon] docs for details.
  # See MapObject#listen_to on how to use events not listed on this object.
  #
  # === Examples:
  #
  #
  #
  class Polygon < MapObject
    attr_reader :points

    # ==== Options:
    # * +points+ - Required. A single location or array of locations representing the points of the polygon.
    #
    # ==== Styling options
    # * +border_colour+ - Optional. The colour of the border, can be a name('red', 'blue') or a hex colour, defaulted to '#00F'
    # * +border_thickness+ - Optional. The thickness of the border in pixels, defaulted to 2.
    # * +border_opacity+ - Optional. The opacity of the border between 0 and 1, defaulted to 0.5.
    # * +fill_colour+ - Optional. The colour that the circle is filled with, defaulted to '##66F'.
    # * +fill_opacity+ - Optional. The opacity of the filled area of the circle, defaulted to 0.5.
    def initialize(options = {})
      options.default! :var => 'polygon', :points => [], 
                       :border_colour => '#00F',
                       :border_thickness => 2,
                       :border_opacity => 0.5,
                       :fill_colour => '#66F',
                       :fill_opacity => 0.5                 

      super

      if create_var?
        self.points = options.extract(:points).arify.collect(&:to_location)
        
        border_colour =  options.extract(:border_colour) 
        border_thickness =  options.extract(:border_thickness) 
        border_opacity =  options.extract(:border_opacity)

        fill_colour = options.extract(:fill_colour)
        fill_opacity = options.extract(:fill_opacity)
        
        self << "#{self.var} = new GPolygon([#{self.points.join(', ')}], #{border_colour.to_js}, #{border_thickness.to_js}, #{border_opacity.to_js}, #{fill_colour.to_js}, #{fill_opacity.to_js});"
      end
    end

    # Adds a point at the given +location+ and updates the shape of the polygon.
    def add_point(location)
      self << "#{self.var}.insertVertex(#{self.last_point_index}, #{location.to_location})"
    end
    
    def click(&block)
      self.listen_to :event => :click, :with => :location, &block
    end

    def last_point_index
      "#{self.var}.getVertexCount() - 1"
    end    

    def to_polygon
      self
    end

    protected
      attr_writer :points

  end
end
