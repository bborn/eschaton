require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class PaneTest < Test::Unit::TestCase

  def test_initialize
    Eschaton.with_global_script do |script|
      map = Google::Map.new
      
      assert_output_fixture 'pane = new GooglePane({cssClass: "pane", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10)), text: "Poly Jean Harvey"});
                             map.addControl(pane);',
                            script.record_for_test {
                              map.add_control Google::Pane.new(:text => 'Poly Jean Harvey')
                            }
                            
      assert_output_fixture 'pane = new GooglePane({cssClass: "pane", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(10, 10)), text: "Poly Jean Harvey"});
                             map.addControl(pane);',                            
                            script.record_for_test {
                              map.add_control Google::Pane.new(:text => 'Poly Jean Harvey', :anchor => :top_right)
                            }
                            
      assert_output_fixture 'pane = new GooglePane({cssClass: "pane", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(10, 30)), text: "Poly Jean Harvey"});
                             map.addControl(pane);',                            
                            script.record_for_test {                            
                              map.add_control Google::Pane.new(:text => 'Poly Jean Harvey', :anchor => :top_right,
                                                               :offset => [10, 30])
                            }
                            
      assert_output_fixture 'pane = new GooglePane({cssClass: "green", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10)), text: "Poly Jean Harvey"});
                             map.addControl(pane);',                            
                            script.record_for_test {
                              map.add_control Google::Pane.new(:text => 'Poly Jean Harvey', :css_class => :green)
                            }
                            
      assert_output_fixture 'pane = new GooglePane({cssClass: "green", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10)), text: "test output for render"});
                            map.addControl(pane);',                            
                            script.record_for_test {
                              map.add_control Google::Pane.new(:partial => 'jump_to', :css_class => :green)
                            }
    end
  end
  
  def test_pane_id
    Eschaton.with_global_script do |script|
      output = 'my_pane = new GooglePane({cssClass: "pane", id: "my_pane", position: new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10)), text: "Poly Jean Harvey"});'
     
      assert_output_fixture output,
                            script.record_for_test {
                              Google::Pane.new(:var => :my_pane, :text => 'Poly Jean Harvey')
                            }

      assert_output_fixture output, 
                            script.record_for_test {
                              Google::Pane.new(:var => 'my_pane', :text => 'Poly Jean Harvey')
                            }
    end
  end
  
end