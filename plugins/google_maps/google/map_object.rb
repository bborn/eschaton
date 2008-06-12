module Google
  
  class MapObject
    include GeneratorObject
    attr_reader :variable
    attr_accessor :create_variable
    
    # :context, :variable, :create_variable
    def initialize(options)
      options.default! :create_variable => true
            
      setup_generator options
      
      self.create_variable = options.extract_and_remove(:create_variable)
      self.variable = options.extract_and_remove(:variable)
    end
        
    alias create_variable? create_variable
        
    # Gets the object but assumes it has already been declared using +:variable+,
    # this allows you do work with abstactions on existing variables.
    def self.existing(options)
      options.assert_valid_keys :variable

      options.default! :create_variable => false

      self.new(options)
    end

    # Sets the name of the local variable that respresents this object.
    # If :random is supplied as the +name+, a random name is assigned to avoid conflicts.
    def variable=(name)
      @variable = if name == :random
                         "_#{rand(1000)}"
                       else
                         name
                       end
    end

    # :with, :on, :body
    # If no :body option is supplied, the results of yield will be used
    def listen_to(event, options = {});
      options.assert_valid_keys :with, :on, :body
    
      block_arguments = options[:with].join(', ') if options[:with]
      script << "GEvent.addListener(#{options[:on] || self.variable}, \"#{event}\", function(#{block_arguments}) {
                  #{options[:body] || yield(*options[:with])}
                 });"
    end

    # TODO - Make pretty and move to appropriate place
    def parse_url_for_javascript(url)
      interpolate_symbol, brackets = '%23', '%28%29'
      url.scan(/#{interpolate_symbol}[\w\.#{brackets}]+/).each do |javascript_variable|
        clean = javascript_variable.gsub(interpolate_symbol, '')
        clean.gsub!(brackets, '()')
        
        url.gsub!(javascript_variable, "' + #{clean} + '")
      end  
      
      url.gsub!('&amp;', '&')
      
      url
    end
    
    protected
      def options_to_fields(options)
        options.each do |key, value|
          method = "#{key}="
          self.send(method, value) if self.respond_to?(method)
        end
      end
  end
  
end

