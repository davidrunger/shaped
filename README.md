[![codecov](https://codecov.io/gh/davidrunger/shaped/branch/master/graph/badge.svg)](https://codecov.io/gh/davidrunger/shaped)

# Shaped

Validate the "shape" of Ruby objects.

## Installation

Add the gem to the `test` group of your application's `Gemfile`. Because the gem is not released via
RubyGems, you will need to install it from GitHub.

```ruby
gem 'shaped', git: 'https://github.com/davidrunger/shaped.git'
```

And then execute:

    $ bundle install

## Usage

[Coming soon!]

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rspec` to run
the tests. You can also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## For maintainers

To release a new version:
1. check out the `master` branch
2. update `CHANGELOG.md`
3. update the version number in `version.rb`
4. `bundle install` (which will update `Gemfile.lock`)
5. commit the changes with a message like `Prepare to release v0.1.1`
6. push the changes to `origin/master` (GitHub) via `git push`
7. run `bin/release`, which will create a git tag for the version and push git commits and tags

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
