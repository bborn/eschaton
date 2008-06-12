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
    @var = options.extract_and_remove(:var)
    @create_var = if options.has_key?(:create_var) 
                    options.extract_and_remove(:create_var)
                  else 
                    true
                  end
  end
  
  # Used to work on an existing javascript variable by setting the +create_var+ option to +false+.
  def self.existing(options)
    options.default! :create_var => false

    self.new(options)
  end
  
  alias create_var? create_var
  
  # Converts the given +method+ and +args+ to a javascript method call with arguments.  
  def method_to_js(method, *args)
    js_method = method.to_s.javascriptify
    args = args.to_js_arguments

    self.script << "#{self.var}.#{js_method}(#{args});"
  end
  
  alias method_missing method_to_js
  
  # Yields a new script proxy to the block and returns the generated output of that script proxy
  def return_script
    script = ScriptProxy.new
    yield script
    
    script.to_s
  end
  
  # Returns the generated javascript.
  def to_s
    @script.to_s
  end

  def script
    @script ||= ScriptProxy.new
  end
  
end

class String
  
  # Returns the camelCase format with the first character as lower case
  #  'zoom=' #=> 'setZoom'
  #  'set_zoom' #=> 'setZoom'
  #  'open_info_window' #=> 'openInfoWindow'
  def javascriptify
    camel_case = if self =~ /=$/ 
                   "set_#{self.chop}"
                 else
                   self
                 end

    camel_case.camelize.gsub(/\b\w/){$&.downcase}
  end
  
end

class Array
  
  # Returns an argument list that can be used when calling a javascript method.
  # Arguments will be converted to there javascript equivalents and seperated by a commas.
  #  [1, 2] #=> 1, 2
  #  [1.5, "Hello"] #=> 1.5, "Hello"
  #  [[1, 2], "Goodbye"] #= > [1, 2], "Goodbye"
  def to_js_arguments
    self.collect {|arg|
      if arg.is_a?(Symbol)
        arg
      else
        arg.to_json
      end
    }.join(', ')
  end
    
end
