# frozen_string_literal: true

require 'simplecov'
if ENV.fetch('CI', nil) == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
SimpleCov.start do
  add_filter(%r{\A/spec/})
end

require 'bundler/setup'
Bundler.require

require 'shaped'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.mock_with(:rspec) do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.expect_with(:rspec) do |c|
    c.syntax = :expect
  end

  config.filter_run_when_matching(:focus)

  config.before(:suite) do
    # Increase the size of the printed output for easier comparison of expected vs actual strings,
    # in the event of a failure involving somewhat lengthy string(s).
    # https://github.com/rspec/rspec-expectations/issues/991#issuecomment-302863645
    RSpec::Support::ObjectFormatter.default_instance.max_formatted_output_length = 2_000
  end
end
