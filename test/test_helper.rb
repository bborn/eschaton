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
  cattr_accessor :output_fixture_base
  
  def assert_output_fixture(fixture, output, message = nil)
    output = if output.generator?
               output.generate
             else
               output.to_s
             end
    
    fixture_base = self.output_fixture_base || '.'
    
    fixture_file = "#{fixture_base}/output_fixtures/#{fixture}"
    fixture_contents = File.read fixture_file

    if fixture_contents != output
      Tempfile.open "output" do |file|
        file << output
        file.flush

        diff = `diff -u #{fixture_file} #{file.path}`
        flunk "Output difference, please review the below diff.\n\n#{diff}"
      end
    else
      assert true
    end
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
    "test output for render"
  end
  
end

Eschaton.current_view = EschatonMockView.new
