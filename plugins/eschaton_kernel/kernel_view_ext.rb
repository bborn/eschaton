module KernelViewExt
  
  # Collects each argument and outputs the results
  #   collect stylesheet_link_tag('map_frame', :media => :all),
  #           javascript_include_tag('jquery'),
  #           some_other_stuff
  def collect(*args)
    args.compact.join("\n")
  end
  
  def javascript(&block)
    update_page do |page|
      Eschaton.with_global_script page, &block
    end
  end

  def run_javascript(&block)
    update_page_tag do |page|
      Eschaton.with_global_script page, &block
    end
  end
  
  # Works in the same way as rails link_to_function except this yields the presentation model specified in +model_name+.
  #
  #  link_to_presentation_model :meeting, 'clear' do |model|
  #    model.clear_search_results
  #  end
  def link_to_presentation_model(model_name, name)
    link_to_function name do |script|
      Eschaton.with_global_script(script) do
        yield model_name.presentation_modelify.new script
      end
    end
  end
  
end