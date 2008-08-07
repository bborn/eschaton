# All methods noted here become available on all rails views and provide helpers relating to google maps.
module GoogleViewExt
  
  # Works in much the same as link_to_function but allows for mapping script to be written within the script block
  #
  #  link_to_map_script("Show info") do |script|
  #    script.map.open_info_window :text => 'I am showing some info'
  #  end
  def link_to_map_script(name, *args, &block)
    link_to_function name, *args do |script|
      Eschaton.with_global_script(script, &block)
    end
  end

  def prepare_info_window_options(options)
    options.default! :include_location => true, :html => {}

    include_location = options.extract_and_remove(:include_location)
    if include_location && params[:location].not_blank?
      options[:url][:location] = params[:location]
    end

    options[:html][:class] = :info_window_form
  end
  
  # Works in exactly the same way as rails +form_remote_tag+ but provides some extra options. This would be used 
  # to create a remote form tag within an info window.
  #
  # ==== Options:
  # * +include_location+ - Optional. Indicates if latitude and longitude +params+(if present) should be include in the +url+, defaulted to +true+.
  def info_window_form(options, &block) #TODO rename => info_window_form_tag
    prepare_info_window_options(options)
    
    form_remote_tag options, &block
  end

  def info_window_form_for(model, model_instance, options, &block)
    prepare_info_window_options(options)
    
    remote_form_for model, model_instance, options, &block
  end
  
  # Includes the required google maps and eschaton javascript files. This must be called in the view or layout 
  # to enable google maps functionality.
  #
  # ==== Options:
  # * +key+ - Optional. The key[http://code.google.com/apis/maps/signup.html] that google maps supplied you with, defaulted to GOOGLE_MAPS_API_KEY.
  # * +include_jquery+ - Optional. Indicates if the jquery file should be included, defaulted to +true+, set this to +false+ if you have already include jQuery.
  def include_google_javascript(options = {})
    options.assert_valid_keys :key, :include_jquery

    options.default! :key => GOOGLE_MAPS_API_KEY if defined?(GOOGLE_MAPS_API_KEY)
    options.default! :include_jquery => true

    jquery_script = self.include_jquery_javascript if options[:include_jquery] == true

    collect javascript_src_tag("http://maps.google.com/maps?file=api&amp;v=2&amp;key=#{options[:key]}", {}),
            jquery_script,
            javascript_include_tag('eschaton')
  end
    
  # Creates a google map div with the given +options+, this is used in the view to display the map.
  #
  # ==== Options:
  # * +id+ - Optional. The id of the map the default being +map+
  # * +fullscreen+ - Optional. A value indicating if the map should be fullscreen and take up all the space in the browser window.
  # * +width+ - Optional. The width of the map in pixels.
  # * +height+ - Optional. The height of the map in pixels.
  # * +style+ - Optional. Extra style attributes to be added to the map provided as standard CSS.
  #
  # ==== Examples:
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
      map_style << "width: #{map_size(options.extract_and_remove(:width))};" if options[:width]
      map_style << "height: #{map_size(options.extract_and_remove(:height))};" if options[:height]
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
  
  private
    def map_size(size)
      if size.is_a?(Numeric)
        "#{size}px"
      else
        size
      end
    end
  
end