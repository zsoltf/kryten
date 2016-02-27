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

  # define work to be done in a class with a run method

  class Work
    include Kryten

    def run
      log "working..."
    end

  end

  # The worker can run on it's own
  Work.new.start        # loop run method in foreground
  Work.new.init_daemon  # loop run method in a daemon process

  # One or more workers can be managed by RedDwarf
  # Power it up by passing a block with an array of workers
  RedDwarf.power_up { Work.new }

  # power_up is non-blocking. Send the power_down message stops all workers
  RedDwarf.power_down


```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zsoltf/kryten


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
