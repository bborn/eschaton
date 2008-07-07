require 'eschaton'
    
# Make sure we reinclude for dev
require 'dispatcher' unless defined? ::ActionController::Dispatcher
ActionController::Dispatcher.to_prepare(:eschaton) do 
  Dependencies.require_or_load 'eschaton'
end
