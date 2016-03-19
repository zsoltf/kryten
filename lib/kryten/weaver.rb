module Kryten::Weaver
  attr_reader :thread, :name

  def initialize name
    @name = name
    log "initializing"
    @running = false
  end

  def init_thread
    @thread = Thread.new { start }
  end

  def run
    log "running"
    work = rand(5)*2;
    log "working for #{work} "
    sleep work
    log "done working"
  end

  def stop
    log "stopping"
    sleep 0.1 while @running
    @thread.kill if @thread
    log "stopped"
  end

end

class Kryten::ThreadedFactory
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
