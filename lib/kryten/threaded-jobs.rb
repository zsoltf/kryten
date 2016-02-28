class Kryten::ThreadedTask
  attr_reader :thread, :name

  def initialize name
    @name = name
    log "initializing"
    @working = false
  end

  def init_thread
    @thread = Thread.new { start }
  end

  def run
    @working = true
    log "running"
    work = rand(10)*2
    log "working for #{work} "
    sleep work
    log "done working"
    @working = false
  end

  def start
    log "starting"
    loop { run; sleep 3 }
  end

  def stop
    log "stopping"
    sleep 0.1 while @working
    @thread.kill if @thread
    log "stopped"
  end

  def log message
    puts "#@name: #{message}"
  end

end

class Kryten::ThreadedJobs
  attr_reader :threads

  def initialize(blocking=false)
    trap(:INT) { stop && exit }
    @bots = Array(yield) if block_given?
    start
    sleep 1 while blocking
  end

  def start
    return "factory already running" if @running
    @bots.each(&:init_thread)
    #binding.pry
    @running = true
    puts 'factory started'
    "factory started"
  end

  def stop
    puts 'stopping factory'
    @bots.map { |bot| Thread.new { bot.stop } }.each(&:join)
    @running = false
    puts 'factory stopped'
    'factory stopped'
  end
end
