# Timestamp API

[![Build Status](https://travis-ci.org/alpinelab/timestamp_api.svg?branch=master)](https://travis-ci.org/alpinelab/timestamp_api)
[![Code Climate](https://codeclimate.com/github/alpinelab/timestamp_api/badges/gpa.svg)](https://codeclimate.com/github/alpinelab/timestamp_api)
[![Test Coverage](https://codeclimate.com/github/alpinelab/timestamp_api/badges/coverage.svg)](https://codeclimate.com/github/alpinelab/timestamp_api/coverage)
[![Gem Version](https://badge.fury.io/rb/timestamp_api.svg)](https://badge.fury.io/rb/timestamp_api)
[![security](https://hakiri.io/github/alpinelab/timestamp_api/master.svg)](https://hakiri.io/github/alpinelab/timestamp_api/master)
[![Dependency Status](https://gemnasium.com/alpinelab/timestamp_api.svg)](https://gemnasium.com/alpinelab/timestamp_api)

This gem is an unofficial set of Ruby bindings for the [Timestamp](https://www.timestamphq.com) API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "timestamp_api"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install timestamp_api

## Usage

Configure your Timestamp API key by setting environment variable `TIMESTAMP_API_KEY` or manually:
```ruby
TimestampAPi.api_key = "YOUR_TIMESTAMP_API_KEY"
```

List all projects:
```ruby
projects = TimestampAPI::Project.all
projects.map(&:name) # => ["A project", "Another project", "One more project"]
```

Find a given project:
```ruby
project = TimestampAPI::Project.find(123456)
project.client.name # => "My beloved customer"
```

### Low level API calls

The above methods are simple wrappers around the generic low-level-ish API request method `TimestampAPI.request` that take a HTTP `method` (verb) and a `path` (to be appended to preconfigured API endpoint URL):
```ruby
TimestampAPI.request(:get, "/projects")        # Same as TimestampAPI::Project.all
TimestampAPI.request(:get, "/projects/123456") # Same as TimestampAPI::Project.find(123456)
```

Response is provided as a [RecursiveOpenStruct](https://github.com/aetherknight/recursive-open-struct) (or as an `Array` of `RecursiveOpenStruct`), thus can be accessed by:
```ruby
project = TimestampAPI.request(:get, "/projects/123456")
project.id          # => 123456
project.name        # => "Awesome project"
project.client.name # => "My beloved customer"
```

## Reverse engineering

As the API is not documented nor even officially supported by Timestamp, we're trying to reverse-engineer it.

:warning: This means that Timestamp can introduce breaking changes within their API without prior notice at any time (and thus break this gem).

It also means that if you're willing to hack into it with us, you're very welcome :+1:

While logged in, the Timestamp API data can be explored from your favourite browser (with a JSON viewer addon, if needed) here: https://api.ontimestamp.com/api

There's also a `bin/console` executable provided with this gem, if you want a REPL to hack around.

### What's implemented already ?

* [x] Project#all
* [x] Project#find

### What's not implemented yet ?

* [ ] _everything else_ :scream:

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/alpinelab/timestamp_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

This code is distributed by [Alpine Lab](http://www.alpine-lab.com) under the terms of the MIT license.

See [LICENCE.md](https://github.com/alpinelab/timestamp_api/blob/develop/LICENSE.md)
