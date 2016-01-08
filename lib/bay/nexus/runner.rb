module Bay::Nexus::Runner

  def start
    log "starting #{self}"
    setup

    @running = true
    Signal.trap("INT", proc { stop_running })
    Signal.trap("TERM", proc { stop_running })

    while @running do
      sleep @timer || 4
      run
    end

    log "stopped #{self}"
  rescue => e
    log "error #{e}"
    #raise
  end

  def run
    log "running #{self}"
  end

  def stop_running
    # no logging here, this is a signal handler
    @running = false
  end

  def setup
    log "setting up #{self}"
  end

  def debug
    log "debugging #{self}"
    setup
    2.times do
      run
      sleep @timer || 4
    end
  end

  def log message
    puts message
  end

end
