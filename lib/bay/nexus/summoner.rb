require 'daemons'

module Daemons
  class Application
    def customstatus(app)
      "i r logger #{app}"
    end
  end
end

module Summoner

  def initialize options={}
    start_daemon
  end

  def start_daemon
    options = {
      log_output: false,
      backtrace: false,
      multiple: true,
      ARGV: ['start'],
      show_status_callback: :customstatus
    }

    name = self.class.to_s.downcase
    @daemon = Daemons.run_proc(name, options) { start }

  end

  def daemon
    # run_proc with :multiple creates an application group (stack)
    # if there are multiple daemons with the same name,
    # the curent daemon is the last entry
    @daemon.applications.last
  end

  def stop
    daemon.stop
  end

  def pid
    daemon.pid.pid
  end

  def status
    daemon.show_status
  end

  def name
    [daemon.pid.progname, daemon.pid.number + 1].join("-")
  end
end
