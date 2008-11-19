require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class Store
  extend ScriptStore
  
  define :before_map_script
  
  #def self.before_map_script
  #  @@before_map_script ||= ScriptExpander.new
  #end

  #def self.clear_before_map_script
  #  @@before_map_script = nil
  #end
  
end

class ExpanderTest < Test::Unit::TestCase

  def test_expander_with_scriptstore    
    generator = Eschaton.javascript_generator

    generator << "Before expander"
    generator << Store.before_map_script
    generator << "After expander"    
    
    Store.before_map_script << "Before Map Script"
    Store.before_map_script.comment "This is before the map script!"
    
    Store.clear(:before_map_script)
    
    assert_output_fixture 'Before expander
                           Before Map Script
                           /* This is before the map script! */
                           After expander',
                           generator
  end

end