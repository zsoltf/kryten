require "kryten/version"
require "kryten/summoner"
require "kryten/lawger"
require "kryten/runner"
require "kryten/helper"
require "kryten/environment"
require "kryten/background-jobs"
require "kryten/threaded-jobs"

module Kryten::Core
  include Kryten::Runner
  include Kryten::Lawger
  include Kryten::Helper
end

module Kryten::Worker
  include Kryten::Lawger
  include Kryten::Helper
end

module Kryten::BackgroundTask
  include Kryten::Summoner
  include Kryten::Core
end

=begin
module Kryten::ThreadedTask
  include Weaver
  include Core
end
=end
