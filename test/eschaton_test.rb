require File.dirname(__FILE__) + '/test_helper'

class EschatonTest < Test::Unit::TestCase
    
  def test_url_for        
    #puts Eschaton.url_for(:controller => :marker, :action => :show, :id => '#marker.id', :other => 'sss')
    
    #puts Eschaton.url_for(:controller => :location, :action => :create, :name => 'My Location',
    #                      :latitude => '#location.lat()', :longitude => '#longitude.long()')
  end
  
  def test_js_object    
    
    gen = Eschaton.javascript_generator
    
    JavascriptObject.global_script = gen
    
    map = Google::Map.new(:var => 'my_map', :center => {:latitude => 34, :longitude => 18.5},
                           :controls => [:small_map, :map_type])

    map.click do |script, overlay, location|
      script.alert('ssss')
    end
    
    map.click do |script, overlay, location|  
      marker = Google::Marker.new(:location => :center, :content => "Hello!!", :icon => :node)  
      marker.hello_world
      map.add_marker marker
    end
      
    map.click do |script, overlay, location|  
      #map.add_marker marker
      script.hello_there
    end
   
    
    puts gen.generate
  end
  
end