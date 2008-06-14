require File.dirname(__FILE__) + '/../../../test/test_helper'

include ActionController

class GoogleMapsTest < Test::Unit::TestCase
   
  def test_to_google_options
   assert_equal '{bounceGravity: 12, title: "My title!", dragable: true}',
                {:dragable => true, :bounce_gravity => 12, :title => "My title!"}.to_google_options
                
   assert_equal '{dragCrossMove: true, icon: local_icon}', 
                {:drag_cross_move => true, :icon => :local_icon}.to_google_options
  end  
  
  def test_to_icon
    icon = Google::Icon.new(:image => "/images/my_image.png")

    # Assert that the outut is the same
    assert_equal icon.to_s, "/images/my_image.png".to_icon.to_s
    assert_equal icon.to_s, :my_image.to_icon.to_s
    assert_equal icon, icon.to_icon
  end
  
  def test_to_location
    location_hash = {:latitude => -34, :longitude => 18.5}
    location = Google::Location.new(location_hash)

    # Assert that the outut is the same    
    assert_equal location.to_s, location.to_location.to_s
    assert_equal location, location.to_location
  end
    
  def test_map
    gmap = Google::Map.new(:center => {:latitude => -34, :longitude => 18.5},
                           :controls => [:small_zoom, :map_type])
    
    gmap.script << gmap.open_info_window(:at => gmap.center, 
                                         :url => {:controller => :blog, :action => :show, :id => 1})
    
    puts gmap.to_s
  end
  
  def test_marker
    marker = Google::Marker.new(:location => {:latitude => -34, :longitude => 18.5},
                                :dragable => true, :title => 'rad yeah!')
    marker.click do |x|
      x.alert('hell')
      x.to_s
    end
    puts marker
  end
  
end
