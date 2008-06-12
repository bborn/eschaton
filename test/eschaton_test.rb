require File.dirname(__FILE__) + '/test_helper'

class JsEschatonTest < Test::Unit::TestCase

  # Replace this with your real tests.
  def test_this_plugin
    map = Google::Map.existing(:variable => 'map')
    
    puts map.to_s
  end
  
  def test_gmap    
    gmap = Google::Map.new(:center => {:latitude => -34, :longitude => 18.5},
                           :controls => [:small_zoom, :map_type])
    
    #puts gmap.open_info_window(:url => '/path/action', :at => {:latitude => -35, :longitude => 19})
    #gmap.alert('hello world!!')
    
    gmap.click do |overlay, location|
      puts overlay
      puts location
      %Q{
        if (g_lat_lng){ 
          //node_arc(map, g_lat_lng.lng(), g_lat_lng.lat());
          //create_node(map, g_lat_lng)
        }
      }
    end
    
    puts gmap.to_s
  end
  
  def test_icon    
    icon = Google::Icon.new(:image => '/images/node.png', :size => '11x12', :anchor => '13x14',
                            :info_window_anchor => '15x16')

    #icon = Google::Icon.new(:image => '/images/node.png')
    #icon = Google::Icon.new(:image => :node)    

    puts icon.to_s    
  end
  
  def test_marker
    marker = Google::Marker.new(:location => {:latitude => 1.0, :longitude => 2.0},
                                :icon => :node)
   
    puts marker.to_s
    
    #map = Google::Map.new(:center => Google::Location.new(-34, 18.5),
    #                :controls => [:small_zoom, :map_type])
    
    #map.overlay(marker)
    
    #puts map.to_s
  end
    
end
