module Kryten::Weaver
  attr_reader :worker
  attr_accessor :workers

  def start_work
    workers.each(&:start_work) if workers

    if worker && worker.alive?
      log 'worker already running'
      return false
    end
    @worker = Thread.new { start }
  end

  def stop_work
    workers.each(&:stop_work) if workers
    stop_running
  end

  def workers
    if block_given?
      @workers = Array(yield)
      return self
    end
    @workers
  end

end

class Kryten::Supervisor
  def self.start(workers)
    start_workers(workers)
    sleep 1 while @started
  end

  def self.start_workers(workers)
    @workers = workers
    @started = true
    Signal.trap("INT", proc { self.stop })
    Signal.trap("TERM", proc { self.stop })
    workers.each(&:start_work)
    self
  end

  def self.workers
    @workers
  end

  def self.stop
    if @started
      workers.each(&:stop_work)
      sleep 1 while @workers.detect(&:running)
      sleep 3
      @started = false
    end
  end

  def self.running?
    @started
  end

end

