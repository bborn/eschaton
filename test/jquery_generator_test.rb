require File.dirname(__FILE__) + '/test_helper'

class JQueryGeneratorTest < Test::Unit::TestCase

  def test_post
    gen = Eschaton.javascript_generator
    
    gen.post(:url => {:controller => :marker, :action => :update, :id => 1}, 
             :params => {:name => 'guilio', :age => 27}) do |data|
      gen << "var i = 1;"
      gen << "alert(#{data});"
      gen.alert("I am done!")
    end

    gen.post(:url => {:controller => :marker, :action => :update, :id => 1}, 
             :form => :my_sweet_form) do |data|
      gen << "var i = 1;"
      gen << "alert(#{data});"
      gen.alert("I am done!")
    end
  end

end
