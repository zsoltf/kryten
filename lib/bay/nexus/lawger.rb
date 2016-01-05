require 'logger'

module Bay
  module Nexus
    module Lawger

      def log_path
        classname = self.class.to_s.gsub('::','_').downcase
        "/tmp/#{classname}.log"
      end

      def log message
        @logger ||= Logger.new(filename)
        @logger.debug message
      end

    end
  end
end
