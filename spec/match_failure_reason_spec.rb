# frozen_string_literal: true

RSpec.describe Shaped::MatchFailureReason do
  subject(:match_failure_reason) do
    Shaped::MatchFailureReason.new(
      path: [2],
      expected: Integer,
      actual: String,
    )
  end

  describe '#to_s' do
    it 'returns a string with the match failure reason info' do
      expect(match_failure_reason.to_s).to eq(
        'Object at `2` is expected to be a Integer but was a String',
      )
    end
  end
end
