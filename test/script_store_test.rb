require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class MyStore 
  extend ScriptStore

  define :before_map_script, :end_of_map_script
end

class OtherStore 
  extend ScriptStore

  define :booya
end

class ScriptStoreTest < Test::Unit::TestCase
  
  def test_meta_methods    
    assert MyStore.respond_to?(:end_of_map_script)
    assert [], MyStore.end_of_map_script
    assert_equal false, MyStore.has_end_of_map_script?

    assert MyStore.respond_to?(:before_map_script)
    assert [], MyStore.before_map_script
    assert_equal false, MyStore.has_before_map_script?

    assert OtherStore.respond_to?(:booya)
    assert [], OtherStore.booya
    assert_equal false, OtherStore.has_booya?

    assert_false MyStore.respond_to?(:booya)
    assert_false OtherStore.respond_to?(:end_of_map_script)  
    assert_false OtherStore.respond_to?(:before_map_script)
  end

  def test_add_and_clear
    puts MyStore.clear_end_of_map_script
    assert [], MyStore.end_of_map_script
    assert_equal false, MyStore.has_end_of_map_script?
        
    MyStore.end_of_map_script << 'var 1 = 1;'
    assert ['var 1 = 1;'], MyStore.end_of_map_script
    assert MyStore.has_end_of_map_script?
    
    MyStore.end_of_map_script << 'var 2 = 2;'
    assert ['var 1 = 1;', 'var 2 = 2;'], MyStore.end_of_map_script
    assert MyStore.has_end_of_map_script?
    
    assert_equal "var 1 = 1;\nvar 2 = 2;", MyStore.clear_end_of_map_script
    assert_false MyStore.has_end_of_map_script?    
  end
    
end