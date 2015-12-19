require "bay/bladerunner/version"

module Bay
  module Bladerunner

    def self.start

      unless self.daemons.empty?
        puts "Bladerunner is already running"
        return
      end

      raise "No Block Given" unless block_given?

      puts "starting all daemons"
      @@daemons = []
      @@daemons << yield
      @@daemons = @@daemons.flatten

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
      status = proc do |replicant|
        { name: [ replicant.daemon.pid.progname,
                  replicant.daemon.pid.number + 1,
        ].join("-"),
        pid: replicant.daemon.pid,
        pid_dir: replicant.daemon.pidfile_dir,
        logfile: replicant.daemon.logfile,
        output: replicant.daemon.output_logfile,
        status: replicant.status,
        object: replicant
        }
      end
      alive = self.alive.map(&status)
      dead = self.dead.map(&status)
      #puts "#{alive.count} running daemons"
      #puts "#{dead.count} dead daemons"
      { alive: alive, dead: dead }
    end

    def self.stop

      unless self.running?
        puts "Bladerunner has not been started yet"
        raise "Bladerunner shut down"
      end

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

    end

    def self.running?
      !self.daemons.empty?
    end

  end
end
