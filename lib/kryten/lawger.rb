require 'logger'

module Kryten::Lawger
  attr_accessor :logger

  def name
    @name || self.class.to_s.gsub('::','-').downcase
  end

  def log_path
    "log/#{name}.log"
  end

  def log(level = :debug, message)
    default_log_format
    logger.progname = name
    logger.send(level, message )
  end

  def logger
    unless @logger
      @logger = Logger.new(log_path)
      default_log_format
    end
    @logger
  end

  def default_log_format
    nil
  end

end
