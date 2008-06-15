# Represents a javascript object on which you can call methods and assign fields.
#
# Any method called on this object will translate the methods into a javascript compatable 
# camelCase method which is called on the +var+. Calls are stacked and javascript is returned by calling to_s.
class JavascriptObject
  attr_reader :var, :create_var
  
  # Options:
  # :var:: => Required. The name of the javascript variable.
  # :create_var:: => Optional. Indicates wheather the javascript variable should be created and assigned, defaulted to +true+.
  def initialize(options = {})
    options.default! :create_var => true
    
    @var = options.extract_and_remove(:var)
    @create_var = options.extract_and_remove(:create_var)
  end
  
  # Used to work on an existing javascript variable by setting the +create_var+ option to +false+.
  def self.existing(options)
    options.default! :create_var => false

    self.new(options)
  end
  
  alias create_var? create_var
  
  # Converts the given +method+ and +args+ to a javascript method call with arguments.  
  def method_to_js(method, *args)
    js_method = method.to_s.lowerCamelize
    args = args.to_js_arguments
    self.script << "#{self.var}.#{js_method}(#{args});"
  end
  
  alias method_missing method_to_js
  
  # Yields a new script proxy to the block and returns the generated output of that script proxy
  def return_script
    script = Eschaton.javascript_generator
    yield script
    
    script.generate
  end
  
  # Returns the generated javascript.
  def to_s
    @script.generate(:error_wrapping => false)
  end
  
  alias to_js to_s
  alias to_json to_s

  def script
    @script ||= Eschaton.javascript_generator
  end
  
end
