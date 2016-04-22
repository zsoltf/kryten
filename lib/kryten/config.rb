require 'yaml'

module Kryten

  module Config

    def base_path
      File.expand_path(File.join(ENV['BUNDLE_GEMFILE'], '..'))
    end

    def configure
      classname = self.name.split('::')
      classname = if classname.one?
                    classname.first.downcase
                  else
                    classname[0...-1].collect(&:downcase).join('-')
                  end
      file = File.open(File.join(self.base_path, "config/#{classname}.yml"))
      YAML.load(file)[classname]
    end

    def config entry=nil
      @config ||= configure
      if entry
        @config.fetch(entry)
      else
        @config
      end
    end
  end

end
