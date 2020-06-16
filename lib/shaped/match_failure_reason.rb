# frozen_string_literal: true

class Shaped::MatchFailureReason
  def initialize(path:, expected:, actual:)
    @path = path
    @expected = expected
    @actual = actual
  end

  def to_s
    "Object at `#{@path.map(&:to_s).join('.')}` is expected " \
    "to be a #{@expected} but was a #{@actual}"
  end
end
