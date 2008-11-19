require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)
    
class GoogleGeneratorExtTest < Test::Unit::TestCase

  def test_global_map_var    
    Eschaton.with_global_script do |script|

      script.google_map_script do
        map = Google::Map.new :center => :cape_town, :zoom => 9
      end

      assert_output_fixture "var map;
                             jQuery(document).ready(function() {
                             window.onunload = GUnload;
                             if (GBrowserIsCompatible()) {
                             map_lines = new Array();
                             map = new GMap2(document.getElementById('map'));
                             track_bounds = new GLatLngBounds();
                             map.setCenter(cape_town);
                             map.setZoom(9);
                             last_mouse_location = map.getCenter();
                             function map_mousemove(map){
                             return GEvent.addListener(map, \"mousemove\", function(location) {
                             last_mouse_location = location;
                             });
                             }
                             map_mousemove_event = map_mousemove(map);} else { alert('Your browser be old, it cannot run google maps!');}
                             })", script
    end
  end
  
  def test_mapping_scripts
    generator = Eschaton.javascript_generator

    generator.google_map_script do

      Google::Scripts.before_map_script do |script|
        script.comment "Before 1"
        script.comment "Before 2"
      end

      Google::Scripts.after_map_script do |script|
        script.comment "After 1"
        script.comment "After 2"
      end

      generator.comment "Map script"
    end

    assert_output_fixture "/* Before 1 */
                           /* Before 2 */
                           jQuery(document).ready(function() {
                           window.onunload = GUnload;
                           if (GBrowserIsCompatible()) {
                           /* Map script */} else { alert('Your browser be old, it cannot run google maps!');}
                           })
                           /* After 1 */
                           /* After 2 */",
                          generator
  end  
  
  
  def test_google_map_script
    Eschaton.with_global_script do |script|
      
      assert_output_fixture :google_map_script_no_body, script.record_for_test {
                                                             script.google_map_script {}
                                                           }

      assert_output_fixture :google_map_script_with_body, script.record_for_test {
                                                            script.google_map_script do
                                                              script.comment "This is some test code!"
                                                              script.alert("Hello!")
                                                            end
                                                          }
      
    end
  end

end
