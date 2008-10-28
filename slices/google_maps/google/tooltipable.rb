# Allows a map object to have tooltips. Currently Google::Marker, Google::Polygon and Google::Line are supported.
module Google::Tooltipable
  attr_reader :tooltip
      
  # Sets the tooltip on the map object with the given +options+. See Google::Tooltip#new for valid options.
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
  #  marker.set_tooltip :text => "This is sparta!", :show => :always, :css_class => :green
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

  # Updates the tooltip with the given +options+. See Google::Tooltip#update_html for valid options.
  #
  # ==== Examples:
  #  marker.update_tooltip :text => "Updated tooltip!"
  #
  #  marker.update_tooltip :partial => 'spot_information'
  def update_tooltip(options)
    self.tooltip.update_html options
  end

  def add_tooltip_to_map(map) # :nodoc:
    self.tooltip.added_to_map(map) if self.tooltip  
  end

  def remove_tooltip_from_map(map) # :nodoc:
    tooltip_var = "tooltip_#{self}"
    self.script.if "typeof(#{tooltip_var}) != 'undefined'" do
      map.remove_overlay tooltip_var
    end
  end

end