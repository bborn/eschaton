$:.reject! { |e| e.include? 'TextMate'} # Rails 2.0 messes with Textmates Builder.rb

# Load up the entire host rails enviroment
require File.dirname(__FILE__) + '/../../../../config/environment'
require 'test_help'

class Test::Unit::TestCase
  cattr_accessor :output_fixture_base

  def assert_output_fixture(output_to_compare, generator, message = nil)  
    if output_to_compare.is_a?(Symbol)
      fixture_base = self.output_fixture_base || '.'
      fixture_file = "#{fixture_base}/output_fixtures/#{output_to_compare}"

      output_to_compare = File.read fixture_file
    end

    output_to_compare.strip_each_line!
    output = generator.generate

    if output_to_compare != output
      left_file = Tempfile.open "left_output"
      left_file << output_to_compare
      left_file.flush

      right_file = Tempfile.open "right_output"
      right_file << output
      right_file.flush

      diff = `diff -u #{left_file.path} #{right_file.path}`
      
      left_file.delete && right_file.delete
        
      flunk "Output difference, please review the below diff.\n\n#{diff}"
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
  
  # TODO - Mix this in for real 
  def protect_against_forgery?
    false
  end

end

Eschaton.current_view = EschatonMockView.new
