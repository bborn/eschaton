module KernelControllerExt

  def run_javascript(&block)
    render :update do |script|
      Eschaton.with_global_script script, &block
    end
  end

  def presentation_model(model_name)
    run_javascript do |script|
      yield model_name.presentation_modelify.new(script)
    end
  end    

end