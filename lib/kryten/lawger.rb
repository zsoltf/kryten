require 'logger'

module Kryten::Lawger
  attr_accessor :logger

  def log_path
    "log/#{name}.log"
  end

  def log message
    default_log_format
    logger.debug(name) { message }
  end

  def logger
    @logger ||= Logger.new(log_path)
  end

  def default_log_format
    nil
  end

end
