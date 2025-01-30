# frozen_string_literal: true

ruby file: '.ruby-version'

source 'https://rubygems.org'

# Specify your gem's dependencies in shaped.gemspec
gemspec

group :development, :test do
  gem 'amazing_print'
  # Remove if/when byebug brings in this dependency for us.
  gem 'irb'
  # Go back to upstream if/when https://github.com/deivid-rodriguez/pry-byebug/pull/ 428 is merged.
  gem 'pry-byebug', github: 'davidrunger/pry-byebug'
  gem 'rake'
  # Remove if/when byebug brings in this dependency for us.
  gem 'reline'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'runger_style', require: false
end

group :development do
  gem 'runger_release_assistant', require: false
end

group :test do
  gem 'rspec'
  gem 'simplecov-cobertura', require: false
end
