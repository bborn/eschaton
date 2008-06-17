require File.dirname(__FILE__) + '/test_helper'

class JavascriptObjectTest < Test::Unit::TestCase
      
  def test_to_js
    assert_equal 'map', :map.to_js
    assert_equal '["one", "two"]', ['one', 'two'].to_js
    assert_equal 'true', true.to_js
    assert_equal 'false', false.to_js
    assert_equal '{"controls": "small_map", "zoom": 15}', ( {:zoom => 15, :controls => :small_map}).to_js
  end
  
  def test_to_js_method
    assert_equal "setZoom", "set_zoom".to_js_method
    assert_equal "setZoom", "zoom=".to_js_method
    assert_equal "setZoomControl", "set_zoom_control".to_js_method
    assert_equal "openInfoWindowHtml", "open_info_window_html".to_js_method    
  end
  
  def test_to_js_arguments
   assert_equal '1, 2', [1, 2].to_js_arguments
   assert_equal '1.5, "Hello"', [1.5, "Hello"].to_js_arguments
   assert_equal '[1, 2], "Goodbye"', [[1, 2], "Goodbye"].to_js_arguments
   assert_equal 'true, false', [true, false].to_js_arguments
   assert_equal 'one, two', [:one, :two].to_js_arguments   
   assert_equal '"map", {"controls": "small_map", "zoom": 15}', 
                ['map', {:zoom => 15, :controls => :small_map}].to_js_arguments
  end

  def test_method_to_js
    obj = JavascriptObject.new(:var => 'map')

    obj.zoom = 12
    obj.set_zoom 12
    obj.zoom_in
    obj.zoom_out
    obj.return_to_saved_position
    obj.open_info_window(:location, "Howdy!")
    obj.update_markers [1, 2, 3]
    obj.set_options_on('map', {:zoom => 15, :controls => :small_map})
    
    assert obj.create_var
    assert obj.create_var?
    assert_output_fixture obj, :method_to_js
  end

  def test_existing
    obj = JavascriptObject.existing(:var => 'map')

    assert_equal 'map', obj.var
    assert_false obj.create_var
    assert_false obj.create_var?    
  end
  
  def test_script
    script = Eschaton.javascript_generator
    obj = JavascriptObject.existing(:var => 'map', :script => script)
    
    assert script, obj.script
  end
  
  def test_as_global_script
    map = JavascriptObject.new(:var => 'map')
    marker = JavascriptObject.new(:var => 'marker')
    icon = JavascriptObject.new(:var => 'icon')

    map.before && marker.before && icon.before

    map.as_global_script do
      map.within && marker.within && icon.within
    end

    map.after && marker.after && icon.after

    assert_output_fixture map, :map_as_global_script
    assert_output_fixture marker, :marker_as_global_script
    assert_output_fixture icon, :icon_as_global_script
  end
    
end
