module JqueryGeneratorExt

  # Will execute the script when the document is ready
  def when_document_ready(&block)    
    script = ScriptProxy.new
    yield script
    
    self << "jQuery(document).ready(function() {
      #{script}
    })"
  end
  
end