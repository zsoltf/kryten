require 'daemons'

module Daemons
  class Application
    def customstatus(app)
      app_name = app.options[:app_name]
      pid = app.pid.pid.to_s
      running = app.running? ? 'running' : 'not running'
      running_and_pid = if app.running? and app.pid.exist?
                          " [pid #{pid}]"
                        end
      running_no_pid = if app.pid.exist? and not app.running?
                         " (but pid-file exists: #{pid}')"
                       end
      "#{app_name}: #{running}#{running_and_pid}#{running_no_pid}"
    end
  end
end

module Kryten::Summoner

  def init_daemon
    options = {
      log_output: false,
      backtrace: false,
      multiple: true,
      ARGV: ['start'],
      show_status_callback: :customstatus
    }

    @daemon = Daemons.run_proc(name, options) { start }

  end

  def daemon
    raise 'Initialize daemon first with init_daemon' unless @daemon
    # run_proc with :multiple creates an application group (stack)
    # if there are multiple daemons with the same name,
    # the curent daemon is the last entry
    @daemon.applications.last
  end

  def start_daemon
    daemon.start
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

end
