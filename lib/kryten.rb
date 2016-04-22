require "kryten/version"
require "kryten/environment"

require "kryten/runner"
require "kryten/lawger"
require "kryten/helper"

require "kryten/weaver"
require "kryten/daemon"
require "kryten/remote"

# TASK
module Kryten::Task
  include Kryten::Runner
  include Kryten::Lawger
  include Kryten::Helper
end

module Kryten::ThreadedTask
  include Kryten::Task
  include Kryten::Weaver
end

module Kryten::BackgroundTask
  include Kryten::Task
  include Kryten::Daemon
end


# JOB
class Kryten::Job
  include Kryten::BackgroundTask
end

class Kryten::ThreadedJob
  include Kryten::ThreadedTask
end

class Kryten::ThreadedVisor
  extend Kryten::ThreadedTask
  def self.setup
    Signal.trap("INT", proc { stop_work })
    Signal.trap("TERM", proc { stop_work })
    super
  end
end
