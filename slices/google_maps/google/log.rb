module Google
  
  # Provides the ability to write debug and test information to a floating log window on the map.
  class Log

    # Writes the given +html+ to the log window.
    def self.write(html)
      JavascriptObject.global_script << "GLog.writeHtml(#{html.interpolate_javascript_vars});"
    end

  end
  
end