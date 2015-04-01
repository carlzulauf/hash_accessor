# HashAccessor

A simple library to provide hash-backed accessors to your ruby objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hash_accessor', github: 'carlzulauf/hash_accessor'
```

And then execute:

    $ bundle

## Usage

Example:

```ruby
require "hash_accessor"

class SimpleExample
  include HashAccessor

  hash_accessor :foo, :yin
end

example = SimpleExample.new(foo: "bar")

example.foo
# => "bar"

example.yin
# => nil

example.yin = "yang"

example.yin
# => "yang"
```

### Assign a hash full of attributes

```ruby
example = SimpleExample.new(foo: "bar", yin: "yang")

example.assign_hash_attributes(foo: "baz")

[example.foo, example.yin]
# => ["baz", "yang"]
```

### Access and assign the hash directly

```ruby
example.hash_attributes
# => {foo: "bar", yin: "yang"}

example.hash_attributes = {foo: "baz", yin: "niy"}

[example.foo, example.yin]
# => ["baz", "niy"]
```

See [`/spec`][spec] folder for additional examples.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/carlzulauf/hash_accessor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[spec]: https://github.com/carlzulauf/hash_accessor/tree/master/spec
