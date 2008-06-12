module JqueryViewExt
  
  def run_ready_script(&block)
    run_javascript{|js| js.when_document_ready(&block)}
  end
  
end