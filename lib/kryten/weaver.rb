module Kryten::Weaver
  attr_reader :worker
  attr_accessor :workers

  def setup
    if workers
      log 'starting workers'
      workers.each(&:start_work)
    end

    if worker && worker.alive?
      log 'worker already running'
      return false
    end
  end

  def start_work
    @worker = Thread.new { start }
  end

  def stop
    workers.each(&:stop) if workers
  end

  def workers
    if block_given?
      @workers = Array(yield)
      return self
    end
    @workers
  end

end
