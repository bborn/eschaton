require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class PolygonTest < Test::Unit::TestCase

  def test_center
    Eschaton.with_global_script do |script|
      
      polygon = Google::Polygon.new :vertices => []
      assert_equal "polygon.getBounds().getCenter()", polygon.center

      my_polygon = Google::Polygon.new :var => :my_polygon, :vertices => []
      assert_equal "my_polygon.getBounds().getCenter()", my_polygon.center

    end
  end

  def test_encoded
    Eschaton.with_global_script do |script|
      assert_output_fixture 'polygon = new GPolygon.fromEncoded({color: "#66F", fill: true, opacity: 0.5, outline: true, polylines: [{color: "#00F", levels: "PFHFGP", numLevels: 18, opacity: 0.5, points: "ihglFxjiuMkAeSzMkHbJxMqFfQaOoB", weight: 2, zoomFactor: 2}]});',
                            script.record_for_test {
                              Google::Polygon.new(:encoded => {:points => 'ihglFxjiuMkAeSzMkHbJxMqFfQaOoB', :levels => 'PFHFGP',
                                                               :num_levels => 18, :zoom_factor => 2})
                            }

      assert_output_fixture 'polygon = new GPolygon.fromEncoded({color: "blue", fill: true, opacity: 0.6, outline: true, polylines: [{color: "red", levels: "PFHFGP", numLevels: 18, opacity: 0.3, points: "ihglFxjiuMkAeSzMkHbJxMqFfQaOoB", weight: 3, zoomFactor: 2}, {levels: "PDFDEP", numLevels: 18, points: "cbglFhciuMY{FtDqBfCvD{AbFgEm@", zoomFactor: 2}]});',
                            script.record_for_test {
                              Google::Polygon.new(:encoded => [{:points => 'ihglFxjiuMkAeSzMkHbJxMqFfQaOoB', :levels => 'PFHFGP', 
                                                                :num_levels => 18, :zoom_factor => 2},
                                                               {:points => 'cbglFhciuMY{FtDqBfCvD{AbFgEm@', :levels => 'PDFDEP', 
                                                                :num_levels => 18, :zoom_factor => 2}],
                                                 :border_colour => 'red',
                                                 :border_opacity => 0.3,
                                                 :border_thickness => 3,
                                                 :fill_colour => 'blue',
                                                 :fill_opacity => 0.6)
                              }
    end
  end

end