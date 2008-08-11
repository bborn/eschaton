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
  
  def presentation_modelify
    "#{self.to_s.classify}PresentationModel".constantize
  end

end

class String
  
  # Escapes +self+ and returns the escaped string.
  def escape
    CGI.escape self
  end
  
end
