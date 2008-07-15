require File.dirname(__FILE__) + '/../../../test/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class MapObjectTest < Test::Unit::TestCase

  def setup
    @script = Eschaton.javascript_generator
    JavascriptObject.global_script = @script

    @map_object = Google::MapObject.new(:var => 'test_object')
  end

  def teardown
    JavascriptObject.global_script = nil
  end
  
  def test_listen_to_with
    # With no parameters in :with
    @map_object.listen_to :event => :dragging do |*args|
      assert_equal 1, args.length
      assert_equal ActionView::Helpers::PrototypeHelper::JavaScriptGenerator, args.first.class
    end

    # With a single parameter in :with
    @map_object.listen_to :event => :drag_end, :with => [:end_location] do |*args|
      assert_equal 2, args.length
      assert_equal ActionView::Helpers::PrototypeHelper::JavaScriptGenerator, args.first.class      
      assert_equal :end_location, args.second
    end

    # With multiple parameters in :with    
    @map_object.listen_to :event => :drag_end, :with => [:start_location, :end_location] do |*args|
      assert_equal 3, args.length
      assert_equal ActionView::Helpers::PrototypeHelper::JavaScriptGenerator, args.first.class      
      assert_equal :start_location, args.second
      assert_equal :end_location, args.third
    end
  end

  def test_listen_to_with_yield_order
    @map_object.listen_to :event => :click, :with => [:overlay, :location],
                               :yield_order => [:location, :overlay] do |*args|
      assert_equal 3, args.length
      assert_equal ActionView::Helpers::PrototypeHelper::JavaScriptGenerator, args.first.class      
      assert_equal :location, args.second
      assert_equal :overlay, args.third
    end
  end
  
  def test_map_object_listen_to_no_args
    @map_object.listen_to :event => :click do
    end

    assert_output_fixture :map_object_listen_to_no_args, @script
  end

  def test_map_object_listen_to_with_args
    @map_object.listen_to :event => :click, :with => [:overlay, :location] do
    end

    assert_output_fixture :map_object_listen_to_with_args, @script
  end

  def test_map_object_listen_to_with_body
    @map_object.listen_to :event => :click, :with => [:location] do |script, location|
      script.comment "This is some test code!"
      script << "var current_location = #{location};"
      script.alert("Hello from test Object!")
    end
    
    assert_output_fixture :map_object_listen_to_with_body, @script
  end

end
