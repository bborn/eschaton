# Provides access to global objects of interest.
class Eschaton # :nodoc:
  cattr_accessor :current_view

  def self.dependencies
    if defined?(ActiveSupport::Dependencies)
      puts 'new dep'      
      ActiveSupport::Dependencies
    else
      puts 'old dep'
      Dependencies
    end
  end

  # works like rails url for only with more options!!!!
  def self.url_for_javascript(options)
    url = self.current_view.url_for(options)

    interpolate_symbol, brackets = '#', '()'
    url.scan(/#{interpolate_symbol.escape}[\w\.#{brackets.escape}]+/).each do |javascript_variable|
      interpolation = javascript_variable.gsub(interpolate_symbol.escape, '')
      interpolation.gsub!(brackets.escape, brackets)

      url.gsub!(javascript_variable, "' + #{interpolation} + '")
    end

    url.gsub!('&amp;', '&')
    
    "'#{url}'"
  end

  # Returns a JavascriptGenerator which is extended by all eschaton slices.
  def self.javascript_generator
    ActionView::Helpers::PrototypeHelper::JavaScriptGenerator.new(self.current_view){}
  end

  def self.with_global_script(script = Eschaton.javascript_generator, options = {})
    options.default! :reset_after => false

    previous_script = unless options[:reset_after]
                        JavascriptObject.global_script
                      end
    
    JavascriptObject.global_script = script

    yield script

    JavascriptObject.global_script = previous_script

    script
  end

  # TODO - Add .global_script and remove JavascriptObject.global_script  
  def self.global_script
    global_script = JavascriptObject.global_script

    if block_given?
      yield global_script
    end

    global_script
  end

end