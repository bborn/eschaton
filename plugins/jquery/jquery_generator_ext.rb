module JqueryGeneratorExt

  # Will execute the script when the document is ready
  # This will yield a ScriptProxy to which you can add script
  #
  #  when_document_ready do |script|
  #    script << "var i = 1;"
  #    script << "alert(i);"
  #  end
  def when_document_ready(&block)    
    script = ScriptProxy.new
    yield script
    
    self << "jQuery(document).ready(function() {
      #{script}
    })"
  end
  
end