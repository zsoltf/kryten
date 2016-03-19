module Kryten::Runner

  def start
    log "starting #{name}"
    setup

    @started = true
    Signal.trap("INT", proc { stop_running })
    Signal.trap("TERM", proc { stop_running })

    while @started do
      sleep @timer || 4
      @running = true
      run
      @running = false
    end

    log "stopped #{name}"
  rescue => e
    log "error #{e}"
    #raise
  end

  def run
    log "running #{name}"
  end

  def stop_running
    # no logging here, this is a signal handler
    @started = false
  end

  def setup
    log "setting up #{name}"
  end

  def debug
    log "debugging #{name}"
    setup
    2.times do
      run
      sleep @timer || 4
    end
  end

  def log message
    puts message
  end

  def name
    self.class.to_s.gsub('::','_').downcase
  end

end
