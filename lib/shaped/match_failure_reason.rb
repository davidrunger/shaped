# frozen_string_literal: true

class Shaped::MatchFailureReason
  include Shaped::ExpectedClassDescriptions

  def initialize(path:, expected_klass:, actual_value:)
    @path = path
    @expected_klass = expected_klass
    @actual_value = actual_value
  end

  def to_s
    if (
      @expected_klass.is_a?(Shaped::Array) && @actual_value.is_a?(Array) ||
        @expected_klass.is_a?(Shaped::Hash) && @actual_value.is_a?(Hash)
    )
      @expected_klass.match_failure_reason(@actual_value).to_s
    else
      "Object at `#{@path.map(&:to_s).join('.')}` is expected to be a " \
      "#{expected_class_descriptor(@expected_klass)} but was a #{@actual_value.class}"
    end
  end
end
