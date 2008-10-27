# Allows a map object to have tooltips, currently Google::Marker and Google::Polygon are supported.
module Google::Tooltipable
  attr_reader :tooltip
      
  # Updates the tooltip with the given +options+. Supports the same +options+ as set_tooltip.
  def update_tooltip(options)
    if self.tooltip
      self.tooltip.update_html options
    else
      self.set_tooltip options
    end
  end  
  
  # Sets the tooltip using either +text+ or +partial+ options as content.
  #
  # To style the tooltip define a 'tooltip' style in your CSS stylesheet.
  # The tooltip can then be shown or hidden by using show!+ and hide!
  #
  # ==== Options:
  # * +text+ - Optional. The text to display in the tooltip.
  # * +partial+ - Optional. Supports the same form as rails +render+ for partials, content of the rendered partial will be
  #   displayed in the tooltip.
  # * +show+ - Optional. If set to +always+ the tooltip will always be visible. If set to +on_mouse_hover+ the 
  #   tooltip will only be shown when the cursor 'hovers' over the maker. If you wish to use your own way of showing
  #   the tooltip set this to +false+, defaulted to +on_mouse_hover+.
  #
  # ==== Examples:
  #  # By default will show when mouse 'hovers' over the marker
  #  marker.set_tooltip :text => "This is sparta!"
  #
  #  # Explicitly indicate that on_mouse_hover used
  #  marker.set_tooltip :text => "This is sparta!", :show => :on_mouse_hover
  #
  #  marker.set_tooltip :text => "This is sparta!", :show => :always
  #
  #  # Open the tool tip yourself at a later stage
  #  marker.set_tooltip :text => "This is sparta!", :show => false
  #
  #  marker.set_tooltip :partial => 'spot_information'
  #
  #  marker.set_tooltip :partial => 'spot_information', :locals => {:information => information},
  #                     :show => :always
  def set_tooltip(options)
    options.default! :on => self

    @tooltip = Google::Tooltip.new(options)
  end

  def add_tooltip_to_map(map)
    self.tooltip.added_to_map(map) if self.tooltip  
  end

  # Removes the tooltip from the +map+
  def remove_tooltip_from_map(map)
    self.tooltip.removed_from_map(map) if self.tooltip  
  end

end