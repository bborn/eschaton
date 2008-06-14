class ActionController::Base
  before_filter :set_global
  
  # Create a presentation model using the given +model_name+
  def presentation_model(model_name)
    model = "#{model_name.to_s.classify}PresentationModel".constantize

    render :update do |page|
      yield model.new(:page => page, :controller => self)
    end
  end

  def set_global
    Eschaton.current_controller = self
    Eschaton.current_view = @template
  end

end