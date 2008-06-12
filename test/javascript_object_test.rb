require File.dirname(__FILE__) + '/test_helper'

class JavascriptObjectTest < Test::Unit::TestCase

  def test_javascriptify
    assert_equal "setZoom", "set_zoom".javascriptify
    assert_equal "setZoom", "zoom=".javascriptify
    assert_equal "setZoomControl", "set_zoom_control".javascriptify
    assert_equal "openInfoWindowHtml", "open_info_window_html".javascriptify    
  end

  def test_to_js_arguments
   assert_equal '1, 2', [1, 2].to_js_arguments
   assert_equal '1.5, "Hello"', [1.5, "Hello"].to_js_arguments
   assert_equal '[1, 2], "Goodbye"', [[1, 2], "Goodbye"].to_js_arguments
   assert_equal '"map", {"zoom": 15, "controls": "small_map"}', 
                ['map', {:zoom => 15, :controls => :small_map}].to_js_arguments
  end

  # Replace this with your real tests.
  def test_this_plugin
    obj = JavascriptObject.new(:var => 'map')

    obj.zoom = 12
    obj.set_zoom 12
    obj.zoom_in
    obj.zoom_out
    obj.return_to_saved_position
    obj.open_info_window(:location, "Howdy!")
    obj.update_markers [1, 2, 3]
    obj.set_options_on('map', {:zoom => 15, :controls => :small_map})

    output = ['map.setZoom(12);',
              'map.setZoom(12);',
              'map.zoomIn();',
              'map.zoomOut();',
              'map.returnToSavedPosition();',
              'map.openInfoWindow(location, "Howdy!");',
              'map.updateMarkers([1, 2, 3]);',
              'map.setOptionsOn("map", {"zoom": 15, "controls": "small_map"});'].join("\n")
    
    assert obj.create_var
    assert obj.create_var?    
    assert_equal "#{output}\n", obj.to_s 
  end
  
  def test_existing
    obj = JavascriptObject.existing(:var => 'map')

    assert_equal 'map', obj.var
    assert_false obj.create_var
    assert_false obj.create_var?    
  end

  def test_return_script
    obj = JavascriptObject.existing(:var => 'map')

    output = obj.return_script do |script|
               assert_equal ScriptProxy, script.class
               
               script << "var i = 1;"
               script << "alert(i);"
             end

    assert_equal "var i = 1;\nalert(i);\n", output
  end
    
end
