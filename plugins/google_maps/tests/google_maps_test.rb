require File.dirname(__FILE__) + '/../../../test/test_helper'

class GoogleMapsTest < Test::Unit::TestCase
    
  def test_map
    gmap = Google::Map.new(:center => {:latitude => -34, :longitude => 18.5},
                           :controls => [:small_zoom, :map_type])
    
    #puts gmap.to_s
    p PluginLoader.plugin_locations
  end
    
end
