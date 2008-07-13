# Represents a javascript object on which you can call methods and assign fields.
#
# Any method called on this object will translate the methods into a javascript compatable 
# camelCase method which is called on the +var+. Calls are stacked and javascript is returned by calling to_s.
class JavascriptObject
  attr_reader :var, :create_var

  # Options:
  # :var::        => Optional. The name of the javascript variable, defaulted to a random name.
  # :create_var:: => Optional. Indicates whether the javascript variable should be created and assigned, defaulted to +true+.
  # :script::     => Optional. The script object to use for generation.
  def initialize(options = {})
    options.default! :var => :random, :create_var => true
    
    self.var = options.extract_and_remove(:var)
    @create_var = options.extract_and_remove(:create_var)
    @script = options.extract_and_remove(:script)
  end

  # Used to work on an existing javascript variable by setting the +create_var+ option to +false+.
  # It is recommended that an existing JavascriptGenerator be supplied as the +script+ option.
  #
  # Supports the same options as new.
  def self.existing(options)
    options[:create_var] = false

    self.new(options)
  end

  alias create_var? create_var

  # Converts the given +method+ and +args+ to a javascript method call with arguments.  
  def method_to_js(method, *args)
    self << "#{self.var}.#{method.to_js_method}(#{args.to_js_arguments});"
  end

  alias method_missing method_to_js

  # Adds +javascript+ to the generator.
  #
  # self << "var i = 10;"
  def <<(javascript)
    self.script << javascript
    
    javascript
  end

  # Returns the name of +var+
  def to_s
    self.var.to_s
  end

  alias to_js to_s
  alias to_json to_s

  protected
    # Returns either the global script generator(if one is set) or this objects script generator.
    def script
      @script || JavascriptObject.global_script
    end

  private
    cattr_accessor :global_script
    
    # Sets the name of the local variable that respresents this object.
    # If :random is supplied as +name+, a random name is assigned to avoid conflicts.
    def var=(name)
      @var = if name == :random
               "_#{rand(2000)}"
             else
               name
             end
    end
    
end
