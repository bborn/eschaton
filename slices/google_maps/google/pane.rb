module Google
  
  class Pane < MapObject
    
    #
    # ==== Options:
    #
    # * +text+ - Optional
    # * +partial+ - Optional
    #
    # * +css_class+, Optional, defaulted to 'pane'
    # * +anchor+ - Optional, defaulted to +top_left+
    # * +offset+ - Optional, defaulted to [10, 10]
    def initialize(options = {})
      options.default! :var => 'pane', :css_class => 'pane', :anchor => :top_left,
                       :offset => [10, 10]

      super

      pane_options = {}

      pane_options[:id] = self.var
      pane_options[:position] = OptionsHelper.to_google_position options
      pane_options[:text] = OptionsHelper.to_content options
      pane_options[:css_class] = options[:css_class].to_s

      if create_var?
        google_options = pane_options.to_google_options(:dont_convert => [:position])
        self << "#{self.var} = new GooglePane(#{google_options});"      
      end
    end

  end
end