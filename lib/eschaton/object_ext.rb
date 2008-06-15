class Object

  def _logger_debug(message)
    RAILS_DEFAULT_LOGGER.debug("eschaton: #{message}") if RAILS_DEFAULT_LOGGER
  end  

  def _logger_info(message)
    RAILS_DEFAULT_LOGGER.info("eschaton: #{message}") if RAILS_DEFAULT_LOGGER
  end

  def _logger_warn(message)
    RAILS_DEFAULT_LOGGER.warn("eschaton: #{message}") if RAILS_DEFAULT_LOGGER
  end
  
  def generator?
    self.is_a?(ActionView::Helpers::PrototypeHelper::JavaScriptGenerator)
  end
  
end
