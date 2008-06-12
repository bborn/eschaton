require File.dirname(__FILE__) + '/../../../test/test_helper'

include ActionController

class GoogleMapsTest < Test::Unit::TestCase
    
  def test_map
    gmap = Google::Map.new(:center => {:latitude => -34, :longitude => 18.5},
                           :controls => [:small_zoom, :map_type])
    
    gmap.script << gmap.open_info_window(:at => :location, 
                                         :url => {:controller => :blog, :action => :show, :id => 1})

    puts gmap.to_s
  end
    
end
