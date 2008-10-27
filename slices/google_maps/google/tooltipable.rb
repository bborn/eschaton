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