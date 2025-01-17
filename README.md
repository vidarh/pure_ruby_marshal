# PureRubyMarshal

A pure Ruby re-implementation of Marshal. This fork has been expanded
to support *most* of Marshal, but some functionality (most notably
support for string encodings and Regexp) has been disabled to make it
work with Mruby, and especially with DragonRuby.

(Note that the *test suite* won't run under Mruby)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pure_ruby_marshal'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pure_ruby_marshal

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pure_ruby_marshal. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
