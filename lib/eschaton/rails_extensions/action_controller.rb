module ActionController # :nodoc:
  class Base # :nodoc:
    before_filter :set_current_view

    def run_javascript(&block)
      render :update do |page|
        Eschaton.with_global_script page, &block
      end
    end

    def set_current_view
      Eschaton.current_view = @template
    end
    
    def presentation_model(model_name)
      render :update do |script|
        Eschaton.with_global_script(script) do
          yield model_name.presentation_modelify.new(script)
        end
      end
    end

  end
end