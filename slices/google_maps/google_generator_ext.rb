module GoogleGeneratorExt
  
  # Any script that is added within the block will execute if the browser is compatible with google maps 
  # and when the document is ready.
  def google_map_script
    self.when_document_ready do      
      self << "window.onunload = GUnload;"
      self << "if (GBrowserIsCompatible()) {"

      yield

      if Google::Scripts.has_end_of_map_script?
        self << Google::Scripts.clear_end_of_map_script
      end

      self << "} else { alert('Your browser be old, it cannot run google maps!');}"
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
  def mapping_script(options = {}, &block)
    options.default! :run_when_doc_ready => true
    
    Eschaton.with_global_script(self) do
      if options[:run_when_doc_ready]
        self.google_map_script &block
      else
        yield

        if Google::Scripts.has_end_of_map_script?
          self << Google::Scripts.clear_end_of_map_script
        end
      end
    end
  end
   
end