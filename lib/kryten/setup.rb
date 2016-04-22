require 'yaml'

module Kryten

  module Setup
    module_function

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
  end

  class Config
    def self.fetch(entry)
      @config ||= Setup.configure
      @config.fetch(entry)
    end
  end

end
