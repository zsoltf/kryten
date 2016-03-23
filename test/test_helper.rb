$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'kryten'
require 'minitest/autorun'
require 'pry'

class Kryten::TestOutput
  @logs = []
  def self.logs
    @logs
  end
  def self.log(message)
    @logs << message
  end
  def self.clear
    @logs = []
  end
end

module Kryten::TestTask
  include Kryten::Task
  include Kryten::Weaver

  def run
    #work = rand(2)+1;
    work = 0.1
    log "working for #{work}"
    sleep work
    log "done working"
  end

  def timer
    0.1
  end

  def log(msg)
    Kryten::TestOutput.log(msg)
  end

end

class Kryten::Tester
  include Kryten::TestTask
end
