module GoogleGeneratorExt
  
  # Any script that is added within the block will execute if the browser is compatible with google maps.
  def if_google_compatible(&block)
    self << "if (GBrowserIsCompatible()) {"
    yield
    self << "} else { alert('Your browser be old, it cannot run google maps!');}"
  end
  
  # Any script that is added within the block will execute if the browser is compatible with google maps 
  # and when the document is ready.
  def google_map_script
    self.when_document_ready do      
      self << "window.onunload = GUnload;"
      self.if_google_compatible do
        yield

        if Google::MappingEvents.end_of_map_script.not_nil?
          self << Google::MappingEvents.clear_end_of_map_script
        end
      end      
    end
  end

  # Used when working on google map objects in RJS templates, makes this generator global to all mapping objects.
  #
  # RJS template:
  #   page.alert("before mapping")
  #
  #   page.mapping_script do
  #     marker = page.map.add_marker :location => {:latitude => 33.4, :longitude => 18.5}
  #     marker.click {page.alert("marker clicked!")}
  #   end
  #
  #   page.alert("after mapping")
  def mapping_script(&block)
    Eschaton.with_global_script self, &block
  end
   
end