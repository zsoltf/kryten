require 'logger'

module Lawger
  def log message
    classname = self.class.to_s.downcase
    filename = "/tmp/#{classname}.log"
    @logger ||= Logger.new(filename)
    @logger.debug message
  end
end
