require 'open3'

require "#{File.dirname(__FILE__)}/eschaton/eschaton"
require "#{File.dirname(__FILE__)}/eschaton/script_store"

Dir["#{File.dirname(__FILE__)}/eschaton/**/*.rb"].each do |file|
  Eschaton.dependencies.require_or_load file
end

SliceLoader.load