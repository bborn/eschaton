module Google

  # Represents a poly line that can be added to a Map. If a method or event is not documented here please 
  # see googles online[http://code.google.com/apis/maps/documentation/reference.html#GPolyline] docs for details.
  class Line < MapObject

    # :vertices, :from, :to
    def initialize(options = {})
      options.default! :var => 'line', :vertices => []

      super

      if create_var?
        if options[:from] && options[:to]
          options[:vertices] << options.extract_and_remove(:from)
          options[:vertices] << options.extract_and_remove(:to)
        end

        vertices = options.extract_and_remove(:vertices).arify.collect(&:to_location)
                
        self << "#{self.var} = new GPolyline(#{vertices.to_js});"
        
        self.style = options unless options.empty?
      end
    end

    # Adds a vertex at the given +location+ and updates the shape of the line.
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

    # :color, :weight, :opacity
    def style=(options)
      self << "#{self.var}.setStrokeStyle(#{options.to_google_options});"
    end

    def click(&block)
      self.listen_to :event => :click, :with => :location, &block
    end

  end
end
