require File.dirname(__FILE__) + '/../../../test/test_helper'

class MapObjectTest < Test::Unit::TestCase

  def test_listen_to
    map_object = Google::MapObject.new(:var => 'map')
    map_object.listen_to :event => :click, :with => [:overlay, :location] do |script, overlay, location|
      assert_not_nil script
      assert_not_nil overlay
      assert_not_nil location
      
      assert_equal ActionView::Helpers::PrototypeHelper::JavaScriptGenerator, 
                   script.class
      assert_equal Symbol, overlay.class
      assert_equal Symbol, location.class      
    end
    
    map_object.listen_to :event => :drag do |script|
      assert_not_nil script
      assert_equal ActionView::Helpers::PrototypeHelper::JavaScriptGenerator, 
                   script.class
      
    end    
  end

end
