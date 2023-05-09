# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in shaped.gemspec
gemspec

group :development, :test do
  gem 'amazing_print'
  gem 'pry-byebug'
  gem 'rake'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'runger_style', require: false
end

group :development do
  gem 'release_assistant', require: false, github: 'davidrunger/release_assistant'
end

group :test do
  gem 'codecov', require: false
  gem 'rspec'
end
