module MapHelper
  
  def init_map
    run_map_script do
      map = Google::Map.new(:controls => [:small_map, :map_type],
                            :center => {:latitude => -33.947, :longitude => 18.462},
                            :zoom => 12)
         
      line = Google::Line.new(:verices => [{:latitude => -33.947, :longitude => 18.462}])
      map.click do |script, overlay, location|
        line.add_vertex location
        #map.open_info_window(:location => location, :text => 'hello cape town!')
      end
    end
  end
  
end
