module KernelControllerExt

  def run_javascript(&block)
    render :update do |script|
      Eschaton.with_global_script script, &block
    end
  end

end