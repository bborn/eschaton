$:.reject! { |e| e.include? 'TextMate'} # Rails 2.0 messes with Textmates Builder.rb

require 'rubygems'

require 'active_support'
require 'action_controller'
require 'action_view'

require 'test/unit'

# Load up the entire host rails enviroment
require File.dirname(__FILE__) + '/../../../../config/environment'
