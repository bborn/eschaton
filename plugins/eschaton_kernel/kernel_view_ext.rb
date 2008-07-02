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
  
end