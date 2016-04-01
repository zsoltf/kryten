# Kryten

Kryten Series 4000 Mechanoid is a modular task runner written in Ruby.
It's meant to run simple recurring tasks in the background using threads or daemons.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kryten'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kryten

## Usage

```ruby

  require 'kryten'
  include Kryten

  # Define work to be done in a class with a run method.
  # This method will be run at an interval defined by the timer method.
  # Execution happens in the background based on the type of task included.

  class Work
    include ThreadedTask

    def run
      log "working..."
    end

  end

  # The worker can run on it's own and responds to interrupt signals.
  Work.new.start        # loop run method in foreground
  Work.new.start_worker # loop run method in a thread

  # A worker can have any number of child workers
  class WorkList
    include ThreadedTask
  end

  WorkList.new('app').workers do
    [Work.new('task1'), Work.new('task2')]
  end

  # Run the work in separate processes instead of threads
  class WorkList
    include BackgroundTask
  end

  class Work
    include BackgroundTask
  end

  WorkList.new('app').workers do
    [Work.new('task1'), Work.new('task2')]
  end


```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zsoltf/kryten


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
