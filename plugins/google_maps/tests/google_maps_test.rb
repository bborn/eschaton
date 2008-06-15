require File.dirname(__FILE__) + '/../../../test/test_helper'

class GoogleMapsTest < Test::Unit::TestCase
       
  def test_to_google_options
   assert_equal '{title: "My title!", dragable: true, bounceGravity: 12}',
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
    marker.click do |script|
      #assert_equal ActionView::Helpers::PrototypeHelper::JavaScriptGenerator, 
      #             script.class
      script[:log].replace_html :partial => 'hello'
      script.hide :element_1, :element_2
    end
    
    puts marker
  end
  
  def test_google_map_script
    gen = Eschaton.javascript_generator
    
    assert gen.respond_to?(:google_map_script)
    
    gen.comment "Before doc ready bloc!"
    
    gen.google_map_script do
      gen.alert('Map alert!!!')
    end
    
    gen.comment "After doc ready bloc!"
    puts gen.generate
  end
  
end
