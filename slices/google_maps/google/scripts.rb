module Google
  
  class Scripts
    extend ScriptStore

    define :end_of_map_script, :before_map_script, :after_map_script
  end

end