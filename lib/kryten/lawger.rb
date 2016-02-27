require 'logger'

module Kryten::Lawger

  def log_path
    "/tmp/#{name}.log"
  end

  def log message
    @logger ||= Logger.new(log_path)
    @logger.debug message
  end

end
