require File.dirname(__FILE__) + '/../../../test/test_helper'

class MapObjectTest < Test::Unit::TestCase

  def test_open_info_window
   script = Eschaton.with_global_script do
              map = Google::Map.new
              #location = Google::Location.new(:latitude => 34.6, :longitude => 18.4)
              map.open_info_window(:location => {:latitude => 34.6, :longitude => 18.4}, 
                                   :url => {:controller => :posts, :action => :show, :id => 1})
                                   
              map.open_info_window(:location => {:latitude => 34.6, :longitude => 18.4}, 
                                   :url => {:controller => :posts, :action => :show, :id => 1},
                                   :include_location => true)
                                  
             map.open_info_window(:location => :client_location, 
                                  :url => {:controller => :posts, :action => :show, :id => 1})

             map.open_info_window(:location => :client_location, 
                                  :url => {:controller => :posts, :action => :show, :id => 1},
                                  :include_location => true)
              
            end

   puts script.generate
  end

end
