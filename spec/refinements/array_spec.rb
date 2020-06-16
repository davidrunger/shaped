# frozen_string_literal: true

RSpec.describe Shaped::Refinements::Array do
  using Shaped::Refinements::Array

  subject(:shaped_array) { Shaped::Array(shape_description) }

  let(:shape_description) { [Numeric] }
  let(:test_array) { [1, 2.0, Rational(3, 4)] }

  describe '#has_shape?' do
    subject(:has_shape?) { test_array.has_shape?(shaped_array) }

    context 'when the shape description is `[Numeric]`' do
      before { expect(shape_description).to eq([Numeric]) }

      context 'when the test array consists of solely Numerics' do
        before { expect(test_array).to eq([1, 2.0, Rational(3, 4)]) }

        it 'returns true' do
          expect(has_shape?).to eq(true)
        end
      end

      context 'when the test array has at least one non-Numeric element' do
        let(:test_array) { [1, 2.0, 'not a number!', Rational(3, 4)] }

        it 'returns false' do
          expect(has_shape?).to eq(false)
        end
      end
    end
  end

  describe '#match_failure_reason' do
    subject(:match_failure_reason) { shaped_array.match_failure_reason(test_array) }

    context 'when the test array matches the shape description' do
      before { expect(shaped_array).to be_matched_by(test_array) }

      it 'returns nil' do
        expect(match_failure_reason).to eq(nil)
      end
    end

    context 'when the test array does not match the shape description' do
      before { expect(shaped_array).not_to be_matched_by(test_array) }

      let(:test_array) { [1, 2.0, 'not a number!', Rational(3, 4)] }

      it 'returns a Shaped::MatchFailureReason instance with the correct info' do
        expect(match_failure_reason).to be_a(Shaped::MatchFailureReason)
        expect(match_failure_reason.to_s).to eq(
          'Object at `2` is expected to be a Numeric but was a String',
        )
      end
    end
  end
end
