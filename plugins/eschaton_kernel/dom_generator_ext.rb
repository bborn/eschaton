module DomGeneratorExt

  # Toggles the given +checkbox+
  def toggle_checkbox(checkbox)
    self << "if($('#{checkbox}').checked){"
    self[checkbox].checked = false
    self << "} else{"
    self[checkbox].checked = true
    self << "}"
  end

end