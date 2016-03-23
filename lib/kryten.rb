require "kryten/version"
require "kryten/summoner"
require "kryten/weaver"
require "kryten/lawger"
require "kryten/runner"
require "kryten/helper"
require "kryten/environment"

module Kryten::Task
  include Kryten::Runner
  include Kryten::Lawger
  include Kryten::Helper
end

module Kryten::DaemonTask
  include Kryten::Task
  include Kryten::Summoner
end

module Kryten::ThreadedTask
  include Kryten::Task
  include Kryten::Weaver
end
