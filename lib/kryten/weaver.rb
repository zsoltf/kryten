module Kryten::Weaver
  attr_reader :worker
  attr_accessor :workers

  def setup
    if workers
      log 'starting workers'
      workers.each(&:start_work)
    end
  end

  def start_work
    if worker && worker.alive?
      log 'worker already running'
      return false
    end

    @started = true
    @worker = Thread.new { start }
  end

  def shutdown
    workers.each(&:stop_running) if workers
  end

  def stop_work
    stop_running
  end

  def workers
    if block_given?
      @workers = Array(yield)
      return self
    end
    @workers
  end

  def log_path
    "/tmp/#{name}.log"
  end

end
