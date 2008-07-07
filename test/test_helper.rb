$:.reject! { |e| e.include? 'TextMate'} # Rails 2.0 messes with Textmates Builder.rb

require 'rubygems'

require 'active_support'
require 'action_controller'
require 'action_controller/integration'
require 'action_view'

require 'test/unit'

# Load up the entire host rails enviroment
require File.dirname(__FILE__) + '/../../../../config/boot'
require File.dirname(__FILE__) + '/../../../../config/environment'

class Test::Unit::TestCase

  def output_fixture(name)
    File.read("output_fixtures/#{name}")
  end

  def assert_output_fixture(output, fixture, message = nil)
    output = if output.generator?
               output.generate
             else
               output.to_s
             end

    assert_equal output, output_fixture(fixture), message
  end

end

class EschatonMockView
  attr_accessor :template_format
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::PrototypeHelper
  include ActionView::Helpers::ScriptaculousHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::RecordIdentificationHelper
  include ActionController::PolymorphicRoutes
    
  def url_for(options)
    options.merge!(:only_path => true)
    ActionController::UrlRewriter.new(ActionController::TestRequest.new, nil).rewrite(options)
  end
  
  def render(options)
    "test output"
  end
  
end

Eschaton.current_view = EschatonMockView.new
