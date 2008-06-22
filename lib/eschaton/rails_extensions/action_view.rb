class ActionView::Base    
  #alias javascript update_page
  #alias run_javascript update_page_tag
  
  def self.extend_with_plugin(extention_module)
    include extention_module
  end
  
  # Collects each argument and outputs the results
  #   collect stylesheet_link_tag('map_frame', :media => :all),
  #           javascript_include_tag('jquery'),
  #           some_other_stuff
  def collect(*args)
    args.join("\n")
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