module Google
  
  # Represents a circle on the map at the given <tt>:location</tt>.
  #
  # ==== Examples:
  #
  #  location = {:latitude => -35.0, :longitude => 18.0}
  #
  #  Google::Circle.new :location => location
  #
  #  Google::Circle.new :location => location, :radius => 1000
  #
  #  Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red'
  #
  #  Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red',
  #                     :border_width => 5
  #
  #  Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red',
  #                     :border_width => 5, :border_opacity => 0.7
  #
  #  Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red',
  #                     :border_width => 5, :border_opacity => 0.7,
  #                     :fill_colour => 'black')
  #
  #  Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red',
  #                     :border_width => 5, :border_opacity => 0.7,
  #                     :fill_colour => 'black', :fill_opacity => 1
  class Circle < MapObject
  
    # ==== Options:
    # * +location+ - Required. The location at which the circle must be placed, this will represent the center of the circle.
    # * +radius+ - Optional. The radius in kilometers of the circle, defaulted to 1.5.
    # * +border_colour+ - Optional. The colour of the border drawn around the circle, defaulted to google maps polygon line colour.
    # * +border_width+ - Optional. The width of the border drawn around the circle, defaulted to 2.
    # * +border_opacity+ - Optional. The opacity of the border drawn around the circle, defaulted to google maps polygon line opacity.
    # * +fill_colour+ - Optional. The colour that the circle is filled with, defaulted to '##0055ff'.
    # * +fill_opacity+ - Optional. The opacity of the filled area of the circle, defaulted to google maps polygon fill opacity.
    def initialize(options = {})
      options.default! :var => :circle, :radius => 1.5, :quality => 40,
                       :border_colour => nil, :border_width => 2, :border_opacity => nil,
                       :fill_colour => '#0055ff', :fill_opacity => nil

      super
      
      @options = options

      self.create!
    end

    # Attaches the block to the "click" event of the circle.
    def click(&block)
      self.listen_to :event => :click, &block
    end

    # Moves the circle to the given +location+.
    def move_to(location)
      @options[:location] = location

      self.recreate!
    end

    protected
      def create!
        arguments = [@options[:radius], @options[:quality], 
                     @options[:border_colour], @options[:border_width], @options[:border_opacity],
                     @options[:fill_colour], @options[:fill_opacity]]
    
        location = Google::OptionsHelper.to_location(@options[:location])

        self << "#{self} = drawCircle(#{location}, #{arguments.to_js_arguments});"        
      end

      def recreate!
        self.remove!
        self.create!
      end

  end
end