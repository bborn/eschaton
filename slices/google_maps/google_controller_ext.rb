module GoogleControllerExt
  
  # Works in the same way as run_javascript but code is treated as google map script.
  #
  #  run_map_script do |script|
  #    map = Google::Map.new(:controls => [:small_map, :map_type],
  #                          :center => {:latitude => -33.947, :longitude => 18.462})
  #  end
  def run_map_script(&block)
    run_javascript do |script|
      script.with_mapping_scripts do
        yield script
       
        script << Google::Scripts.extract(:end_of_map_script)
      end
    end
  end

end