require 'logger'

module Bay
  module Nexus
    module Lawger

      def log message
        classname = self.class.to_s.gsub('::','_').downcase
        filename = "/tmp/#{classname}.log"
        @logger ||= Logger.new(filename)
        @logger.debug message
      end

    end
  end
end
