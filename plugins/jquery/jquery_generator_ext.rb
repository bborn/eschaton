module JqueryGeneratorExt

  # Any script that is added within the block will execute when the document is ready.
  #
  #  when_document_ready do
  #    script << "var i = 1;"
  #    script << "alert(i);"
  #    script.alert('hello world!')
  #  end
  def when_document_ready    
    self << "jQuery(document).ready(function() {"
    yield
    self << "})"
  end
  
end