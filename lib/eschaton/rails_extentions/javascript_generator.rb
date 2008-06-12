class ActionView::Helpers::PrototypeHelper::JavaScriptGenerator
  
  def self.extend_with_plugin(extention_module)
    include extention_module
  end

  # Collects each argument and outputs the results to the script generator
  def collect(*args)
    self << args.join("\n")
  end

  # Writes out liternal javascript by reading it from a .js file.
  # The file is assumed to reside in the default rails javascript directory(public/javascripts)
  def inline_from_file(name)
    inline_script File.read("#{RAILS_ROOT}/public/javascripts/#{name}.js")
  end
  
  # Writes out literal javascript
  # Example:
  #   script.inline "var i = 1; alert(i); do_other_stuff();"
  def inline
    inline_script yield
  end

  private
    def inline_script(script)
      self << script if (!script.blank?) #TODO - use quiver_cores not_blank?
    end

end