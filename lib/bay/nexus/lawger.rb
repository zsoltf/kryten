require 'logger'

module Bay
  module Nexus
    module Lawger

      def log message
        classname = self.class.to_s.downcase.gsub!('::', '_')
        filename = "/tmp/#{classname}.log"
        @logger ||= Logger.new(filename)
        @logger.debug message
      end

    end
  end
end
