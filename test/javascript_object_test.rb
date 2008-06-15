require File.dirname(__FILE__) + '/test_helper'

class JavascriptObjectTest < Test::Unit::TestCase
      
  def test_to_js
    assert_equal 'map', :map.to_js
    assert_equal '["one", "two"]', ['one', 'two'].to_js
    assert_equal 'true', true.to_js
    assert_equal 'false', false.to_js
    assert_equal '{"controls": "small_map", "zoom": 15}', ( {:zoom => 15, :controls => :small_map}).to_js
  end
  
  def test_lowerCamelize
    assert_equal "setZoom", "set_zoom".lowerCamelize
    assert_equal "setZoom", "zoom=".lowerCamelize
    assert_equal "setZoomControl", "set_zoom_control".lowerCamelize
    assert_equal "openInfoWindowHtml", "open_info_window_html".lowerCamelize
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

  def test_return_script
    obj = JavascriptObject.existing(:var => 'map')

    output = obj.return_script do |script|
               assert_equal ActionView::Helpers::PrototypeHelper::JavaScriptGenerator, script.class
               
               script << "var i = 1;"
               script << "alert(i);"
             end

    assert_equal "var i = 1;\nalert(i);", output
  end
    
end
