$:.reject! { |e| e.include? 'TextMate'} # Rails 2.0 messes with Textmates Builder.rb

require 'rubygems'

require 'active_support'
require 'action_controller'
require 'action_controller/integration'
require 'action_view'

require 'test/unit'

# Load up the entire host rails enviroment
require File.dirname(__FILE__) + '/../../../../config/environment'


class EschatonGlobalMock
  
  def url_for(options)
    options.merge!(:only_path => true)
    ActionController::UrlRewriter.new(ActionController::TestRequest.new, nil).rewrite(options)
  end
  
end

mock = EschatonGlobalMock.new

EschatonGlobal.current_controller = mock
EschatonGlobal.current_view = mock
