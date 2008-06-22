# All methods noted here become available on all rails views and provide helpers relating to google maps.
module GoogleViewExt

  # Works in exactly the same was as rails form_remote_tag but provides readability. This would be used to create a 
  # remote form tag within a info window.
  def info_window_form(options, &block)
    form_remote_tag options, &block
  end
  
  # Includes the required google maps javascript as well as jquery. This must be called in the view or layout 
  # to enable google maps functionality.
  #
  # Options:
  # key:: => Required. The key[http://code.google.com/apis/maps/signup.html] that google maps supplied you with.
  def include_google_javascript(options)
    options.assert_valid_keys :key
    
    collect javascript_src_tag("http://maps.google.com/maps?file=api&amp;v=2&amp;key=#{options[:key]}", {}),
            javascript_include_tag('jquery')
  end
    
  # Creates a google map div with the given +options+, this is used in the view to display the map.
  #
  # Options:
  # :id::         => Optional. The id of the map the default being +map+
  # :fullscreen:: => Optional. A value indicating if the map should be fullscreen and take up all the space in the browser window.
  # :width::      => Optional. The width of the map in pixels.
  # :height::     => Optional. The height of the map in pixels.
  # :style::      => Optional. Extra style attributes to be added to the map provided as standard CSS.
  #
  # Examples:
  #   google_map :fullscreen => true
  #   google_map :width => 600, :height => 650
  #   google_map :width => 600, :height => 650, :style => 'border: 1px dashed black; margin: 10px'
  #   google_map :id => 'my_cool_map'
  def google_map(options = {})
    options.assert_valid_keys :id, :fullscreen, :width, :height, :style
    
    options[:id] ||= 'map'
    
    map_style = options[:style] || ""
    
    if options.extract_and_remove(:fullscreen)
      map_style << "position: absolute; top: 0; left: 0;
                    height: 100%; width: 100%;
                    overflow: hidden;"
    else
      map_style << "width: #{options.extract_and_remove(:width)}px;" if options[:width]
      map_style << "height: #{options.extract_and_remove(:height)}px;" if options[:height]
    end
    
    options[:style] = map_style
    
    content_tag :div, nil, options
  end

  # Works in the same way as run_javascript but code is treated as google map script.
  #
  #  run_map_script do |script|
  #    map = Google::Map.new(:controls => [:small_map, :map_type],
  #                          :center => {:latitude => -33.947, :longitude => 18.462})
  #  end
  def run_map_script(&block)
    run_javascript do |script|
      script.google_map_script {yield script}
    end
  end
  
end