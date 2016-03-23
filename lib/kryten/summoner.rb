# WARNING: Legacy Code

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

module Kryten::RedDwarf

  def self.start

    unless self.daemons.empty?
      puts "BackgroundFactory is already running"
      return
    end

    raise "No Block Given" unless block_given?

    puts "starting all daemons"
    @@daemons = []
    @@daemons << yield
    @@daemons = @@daemons.flatten
    @@daemons.each { |d| d.init_daemon }

    self.can_shutdown = true

  end

  def self.daemons
    (@@daemons ||= [])
  end

  def self.daemon name
    self.daemons.detect { |d| d.name == name }
  end

  def self.alive
    self.daemons.select(&:pid)
  end

  def self.dead
    self.daemons - self.alive
  end

  def self.monitor
    self.start unless self.running?
    self.status
  end

  def self.status
    status = proc do |job|
      {
        name: job.daemon.pid.progname,
        pid: job.daemon.pid,
        pid_dir: job.daemon.pidfile_dir,
        logfile: job.daemon.logfile,
        output: job.daemon.output_logfile,
        status: job.status,
        object: job
      }
    end
    alive = self.alive.map(&status)
    dead = self.dead.map(&status)
    #puts "#{alive.count} running daemons"
    #puts "#{dead.count} dead daemons"
    { alive: alive, dead: dead }
  end

  def self.run job
    self.can_shutdown = false
    daemon = self.daemon job
    if daemon.pid
      puts "daemon #{daemon} is still running"
    else
      daemon.start_daemon
    end
    self.can_shutdown = true
  end

  def self.halt job
    daemon = self.daemon job
    if daemon.pid
      daemon.stop
    else
      puts "daemon #{daemon} was not running"
    end
  end

  def self.can_shutdown= bool
    @sd = bool
  end

  def self.can_shutdown
    @sd
  end

  def self.stop

    return unless self.can_shutdown

    if self.running?
      puts "stopping all daemons"
      @@daemons.count.times do
        daemon = @@daemons.pop
        if daemon.pid
          pid = Process.fork { daemon.stop }
          Process.detach(pid)
        else
          puts "daemon #{daemon} was not running"
        end
      end
    else
      puts "BackgroundFactory has not been started yet"
    end

  end

  def self.running?
    !self.daemons.empty?
  end

end
