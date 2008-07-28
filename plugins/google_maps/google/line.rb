module Google

  # Represents a poly line that can be added to a Map. If a method or event is not documented here please 
  # see googles online[http://code.google.com/apis/maps/documentation/reference.html#GPolyline] docs for details.
  # See MapObject#listen_to on how to use events not listed on this object.
  class Line < MapObject

    # :vertices, :from, :to, :editable
    #
    #
    def initialize(options = {})
      options.default! :var => 'line', :vertices => [], :editable => false

      super

      if create_var?
        options[:vertices] << options.extract_and_remove(:from) if options[:from]  
        options[:vertices] << options.extract_and_remove(:to) if options[:to]

        vertices = options.extract_and_remove(:vertices).arify.collect(&:to_location)
        
        self << "#{self.var} = new GPolyline(#{vertices.to_js});"
        
        self.enable_drawing! if options.extract_and_remove(:drawable)
        self.style = options unless options.empty?
      end
    end

    # Adds a vertex at the given +location+ and updates the shape of the line.
    # +location+ can be a Location or whatever Location#new supports 
    def add_vertex(location)
      self << "#{self.var}.insertVertex(#{self.var}.getVertexCount(), #{location})"
    end

    # The length of the line along the surface of a spherical earth.
    # The +format+ can be +meters+ or +kilometers+, defaulted to +meters+.
    def length(format = :meters)
      length = "#{self.var}.getLength()"
      length = "#{length} / 1000" if format == :kilometers

      length
    end

    # Changes the style of the line. See 
    # options[http://code.google.com/apis/maps/documentation/reference.html#GPolyStyleOptions]that are supported.
    def style=(options)
      self << "#{self.var}.setStrokeStyle(#{options.to_google_options});"
    end

    # Allows a user to construct (or modify) a line by clicking on additional points on the map.
    # options[http://code.google.com/apis/maps/documentation/reference.html#GPolyEditingOptions] that are supported.
    def enable_drawing!(options = {})
      self << "#{self.var}.enableDrawing(#{options.to_google_options})"
    end
    
    def click(&block)
      self.listen_to :event => :click, :with => :location, &block
    end

  end
end
