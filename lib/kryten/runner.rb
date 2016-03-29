module Kryten::Runner
  attr_accessor :timer
  attr_reader :running, :started

  def initialize title=nil
    @name, @running, @started = title, false, false
  end

  def setup
    log "setting up"
    Signal.trap("INT", proc { stop_running })
    Signal.trap("TERM", proc { stop_running })
  end

  def start
    before_setup
    setup
    after_setup

    log "started"
    @started = true

    while started do
      sleep timer
      @running = true
      before_run
      run
      after_run
      @running = false
    end

    log "stopped"
    true
  rescue => e
    log :error, "error: #{e} - from: #{e.backtrace.first}"
    raise
  end

  def timer
    @timer || 4
  end

  # stop the loop
  def stop_running
    @started = false
    shutdown
  end

  def debug
    log "debugging"
    setup
    2.times do
      run
      sleep timer
    end
  end

  def log message
    puts [name, message].join(': ')
  end

  def name
    @name || self.class.to_s.gsub('::','-').downcase
  end

  def status
    log [started ? 'on and ' : 'off and ',
         running ? 'running' : 'sleeping'].join
    started
  end

  # hook methods
  def before_setup; nil; end
  def after_setup; nil; end
  def before_run; nil; end
  def run; nil; end
  def after_run; nil; end
  def shutdown; nil; end

end
