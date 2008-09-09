Dir["#{File.dirname(__FILE__)}/eschaton/**/*.rb"].each do |file|
  Dependencies.require_or_load file
end

SliceLoader.load