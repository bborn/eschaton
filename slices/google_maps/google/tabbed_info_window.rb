module Google
      
  # TODO - Merge all this into the one and only InfoWindow
  class TabbedInfoWindow < MapObject

    def initialize(options = {})
      super
      self << "tabs = [];"
      @tabs = []
    end
    
    def add_tab(options)
      #InfoWindow.build_content(options) do |content|
      #  self << "tabs.push(new GInfoWindowTab(#{options[:title].to_js}, \"<div style=\'border: solid 1px red; width: 250px; height: 350px;\'>hello boss<br/>More please<br/>tdasdasdas<br/>dasdasdasda<br/>adasdasda<br/></div>\"));"
      #end
    end

    def open(options = {})
      options.default! :location => :center
      location = Google::OptionsHelper.to_location(options[:location])
      
      self << "center = #{self.var}.getCenter();" if location == :center
      
      self << "#{self.var}.openInfoWindowTabs(#{location}, tabs);"
    end

  end
end