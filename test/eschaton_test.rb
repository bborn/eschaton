require File.dirname(__FILE__) + '/test_helper'

class EschatonTest < Test::Unit::TestCase

  def test_global_url_for
  end
  
  def test_javascript_generator
    
    gen = Eschaton.javascript_generator
    gen.alert('Clearing log...')
    gen[:log].replace_html '...'
    
    #puts gen.to_s(:one => 1, :two => 2)
    puts gen.generate(:error_wrapping => true)
    puts ''
    puts gen.generate
    puts ''
    puts gen.generate(:inline => true)
    
  end
     
end
