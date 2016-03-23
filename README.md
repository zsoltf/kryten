# Kryten

Kryten Series 4000 Mechanoid is a modular task runner written in Ruby.

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

  # define work to be done in a class with a run method

  class Work
    include ThreadedTask

    def run
      log "working..."
    end

  end

  # The worker can run on it's own and responds to the interrupt signal.
  Work.new.start        # loop run method in foreground
  Work.new.start_worker # loop run method in a thread

  # Two or more workers can be managed by the Supervisor
  tasks = []
  tasks << FirstTask.new
  tasks << SecondTask.new
  Supervisor.start(tasks)


```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zsoltf/kryten


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
