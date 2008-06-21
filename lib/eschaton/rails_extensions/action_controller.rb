class ActionController::Base
  before_filter :set_global
  
  # Create a presentation model using the given +model_name+
  def presentation_model(model_name)
    model = "#{model_name.to_s.classify}PresentationModel".constantize

    render :update do |page|
      Eschaton.with_global_script page do
        yield model.new(page)
      end
    end
  end
  
  def run_javascript(&block)
    render :update do |page|
      Eschaton.with_global_script page, &block
    end
  end

  def set_global
    Eschaton.current_view = @template
  end

end