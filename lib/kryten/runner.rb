module Kryten::Runner
  attr_accessor :timer
  attr_reader :running, :started

  def initialize title=nil
    @name, @running, @started = title, false, false
    log "initializing"
    Signal.trap("INT", proc { stop_running })
  end

  def start
    setup
    log "starting"
    @started = true

    while started do
      sleep timer
      @running = true
      run
      @running = false
    end

    log "stopped"
    true
  rescue => e
    log "error #{e}"
    #raise
  end

  def run
    log "running"
  end

  def timer
    @timer || 4
  end

  def stop_running
    @started = false
  end

  def setup
    log "setting up"
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

end
