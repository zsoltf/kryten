require 'drb'

class Kryten::RemoteControl
  include DRbUndumped
  attr_reader :job, :workers
  def initialize(job)
    puts "Initialized #{job.name} server on pid #{Process.pid}"
    @job = job
    Signal.trap("TERM") { shutdown }
    Signal.trap("INT") { shutdown }
  end

  def start name=nil
    if name
      worker(name).start_work
    else
      puts "Starting #{job.name}"
      job.start_work
    end
  end

  def stop name=nil
    if name
      worker(name).stop_work
    else
      puts "Stopping #{job.name}"
      val = job.stop_work
      sleep job.timer
      return val
    end
  end

  def shutdown
    puts "Terminating #{job.name}"
    stop
    sleep 2
    exit 0
  end

  def status name=nil
    if name
      worker(name).status
    else
      job.status
    end
  end

  def worker name
    job.workers.detect {|w| w.name == name}
  end

  def workers
    job.workers
  end

  def started
    job.workers.select(&:started)
  end

  def stopped
    job.workers.reject(&:started)
  end

end
