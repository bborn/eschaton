class ActionView::Base
  alias javascript update_page
  alias run_javascript update_page_tag
  
  # Reads the contents of a .js file and wraps it in a <script> tag.
  # The file is assumed to reside in the default rails javascript directory(public/javascripts)
  def run_javascript_file(name)
    run_javascript {|js| js.inline_from_file(name)}
  end

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

end