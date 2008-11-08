module JqueryViewExt
  
  # Includes the required jQuery javascript files. This must be called in the view or layout 
  # to enable jQuery functionality.
  #
  # ==== Options:
  # * +avoid_conflicts+ - Optional. Indicates if jQuery should avoid conflicting with existing javascript libraries, defaulted to +true+.
  def include_jquery_javascript(options = {})
    options.assert_valid_keys :avoid_conflicts
    options.default! :avoid_conflicts => true

    conflict_script = if options[:avoid_conflicts] == true
                        run_javascript do |script|
                          script.avoid_conflicts!
                        end
                      end

    collect javascript_include_tag('jquery'),
            conflict_script
  end

end