module GoogleGeneratorExt
  
  # Any script that is added within the block will execute if the browser is compatible with google maps.
  def if_google_compatible(&block)
    self << "if (GBrowserIsCompatible()) {"
    yield
    self << "}"
  end
  
  # Any script that is added within the block will execute if the browser is compatible with google maps 
  # and when the document is ready.
  def google_map_script
    self.when_document_ready do
      self.if_google_compatible do
        yield
      end
    end
  end
   
end