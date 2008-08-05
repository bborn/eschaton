module Google
  
  # Represents system wide "events" that ruby code can add script to and they will be outputed in their
  # relevant places.
  class MappingEvents

    # TODO - Figure out and document
    def self.end_of_map_script
      @@end_of_map_script ||= []
    end

    # TODO - Figure out and document   
    def self.clear_end_of_map_script
      end_script = @@end_of_map_script

      @@end_of_map_script = nil

      end_script
    end
  
  end
end