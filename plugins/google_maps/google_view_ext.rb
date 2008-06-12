module GoogleViewExt

  # Includes the required Google Maps javascript files. This must be called in the view or layout to enable google
  # maps functionality. Valid options are:
  # 
  # <tt>:key</tt> =>  The key that Google Maps supplied you with
  def include_google_javascript(options)
    javascript_src_tag "http://maps.google.com/maps?file=api&amp;v=2&amp;key=#{options[:key]}", {}
  end
  
  # Creates a google map dom object as need be
  # 
  # :id, :fullscreen
  # :width, :height
  def google_map(options)
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
  
end