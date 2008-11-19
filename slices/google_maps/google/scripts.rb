module Google
  
  class Scripts
    extend ScriptStore

    define :before_map_script, :after_map_script, :end_of_map_script
  end

end