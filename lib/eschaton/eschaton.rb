# Provides access to global objects of interest.
class Eschaton
  cattr_accessor :current_view
  
  # works like rails url for only with more options!!!!
  #
  #  TODO - Document javascript variable interpolation
  def self.url_for(options)    
    url_with_javascript self.current_view.url_for(options)
  end

  
  # Returns a JavascriptGenerator which is extended by all eschaton plugins.
  def self.javascript_generator
    ActionView::Helpers::PrototypeHelper::JavaScriptGenerator.new(self.current_view){}
  end

  def self.with_global_script(script)
    JavascriptObject.global_script = script
    
    yield script
    
    JavascriptObject.global_script = nil
  end

  private
  
    def self.url_with_javascript(url)
      has_javascript_interpolation = false
      interpolate_symbol, brackets = '#', '()'
      url.scan(/#{interpolate_symbol.escape}[\w\.#{brackets.escape}]+/).each do |javascript_variable|
        interpolation = javascript_variable.gsub(interpolate_symbol.escape, '')
        interpolation.gsub!(brackets.escape, brackets)

        url.gsub!(javascript_variable, "' + #{interpolation} + '")
        
        has_javascript_interpolation = true
      end

      if has_javascript_interpolation
        url.gsub!("&amp;", "&")
        #url = "'#{url}'"
      end

      "'#{url}'"
    end

end