class ActionController::Base
  
  def presentation_model(model_name)
    model = "#{model_name.to_s.classify}PresentationModel".constantize

    render :update do |page|
      yield model.new(:page => page, :controller => self)
    end
  end
  
end