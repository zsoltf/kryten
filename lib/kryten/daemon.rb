require 'daemons'

module Kryten::Daemon
  attr_reader :worker
  attr_accessor :workers

  def setup
    if workers
      log 'starting workers'
      workers.each(&:start_work)
    end
  end

  def start_work
    if worker && worker.running?
      log 'worker already running'
      return false
    end

    options = {
      dir_mode: :script,
      dir: '/tmp/',
      log_output: false,
      backtrace: false,
      multiple: false,
      ARGV: ['start']
    }
    @worker.start_all if @worker
    @worker ||= Daemons.run_proc(name, options) { start }
  end

  def log_path
    "/tmp/#{name}.log"
  end

  def stop
    if workers
      workers.each { |w| fork { w.stop }}
      Process.waitall
    end
    worker.stop_all if worker
  end

  def workers
    if block_given?
      @workers = Array(yield)
      return self
    end
    @workers
  end

  def status
    worker && worker.show_status || 'off'
  end

  def running
    worker && worker.running? || false
  end

end
