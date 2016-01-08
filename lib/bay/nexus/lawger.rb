require 'logger'

module Bay::Nexus::Lawger

  def log_path
    classname = self.class.to_s.gsub('::','_').downcase
    "/tmp/#{classname}.log"
  end

  def log message
    @logger ||= Logger.new(log_path)
    @logger.debug message
  end

end
