require "kryten/version"
require "kryten/environment"

require "kryten/runner"
require "kryten/lawger"
require "kryten/helper"

require "kryten/weaver"
require "kryten/daemon"

module Kryten::Task
  include Kryten::Runner
  include Kryten::Lawger
  include Kryten::Helper
end

module Kryten::ThreadedTask
  include Kryten::Task
  include Kryten::Weaver
end

class Kryten::ThreadVisor
  extend Kryten::ThreadedTask
  def self.setup
    Signal.trap("INT", proc { stop_work })
    Signal.trap("TERM", proc { stop_work })
    super
  end
end

module Kryten::BackgroundTask
  include Kryten::Task
  include Kryten::Daemon
end
