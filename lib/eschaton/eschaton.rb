# Provides access to global objects of interest.
class Eschaton
  cattr_accessor :current_view
  
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

  # Returns a JavascriptGenerator which is extended by all eschaton plugins.
  def self.javascript_generator
    ActionView::Helpers::PrototypeHelper::JavaScriptGenerator.new(self.current_view){}
  end
  
  def self.with_global_script(script = Eschaton.javascript_generator)
    JavascriptObject.global_script = script
    
    yield script
    
    JavascriptObject.global_script = nil
    
    script
  end

end