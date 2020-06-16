# frozen_string_literal: true

RSpec.describe Shaped::Array do
  subject(:shaped_array) { Shaped::Array(shape_description) }

  let(:shape_description) { [Numeric] }
  let(:test_array) { [1, 2.2, 1_024] }

  describe '#initialize' do
    context 'when the shape description is an array of one class' do
      let(:shape_description) { [String] }

      it 'does not raise an error' do
        expect { shaped_array }.not_to raise_error
      end
    end

    context 'when the shape description is an array of one non-class element' do
      let(:shape_description) { ['two'] }

      it 'raises an error' do
        expect { shaped_array }.to raise_error(
          Shaped::InvalidShapeDescription,
          'The element of a Shaped::Array description must be a class (ex: `[String]`).',
        )
      end
    end

    context 'when the shape description is an array of multiple classes' do
      let(:shape_description) { [Integer, String] }

      it 'raises an error' do
        expect { shaped_array }.to raise_error(
          Shaped::InvalidShapeDescription,
          'A Shaped::Array description must be an array with exactly one element (ex: `[String]`).',
        )
      end
    end
  end

  describe '#matched_by?' do
    subject(:matched_by?) { shaped_array.matched_by?(test_array) }

    context 'when the shape description is `[Numeric]`' do
      before { expect(shape_description).to eq([Numeric]) }

      context 'when the test array is an empty array' do
        let(:test_array) { [] }

        context 'when executed in strict mode' do
          around do |spec|
            Shaped.strict_mode do
              spec.run
            end
          end

          it 'returns false' do
            expect(matched_by?).to eq(false)
          end
        end

        context 'when executed in lax mode' do
          around do |spec|
            Shaped.lax_mode do
              spec.run
            end
          end

          it 'returns true' do
            expect(matched_by?).to eq(true)
          end
        end
      end

      context 'when the test array is an array of solely Numerics' do
        before { expect(test_array).to eq([1, 2.2, 1_024]) }

        it 'returns true' do
          expect(matched_by?).to eq(true)
        end
      end

      context 'when the test array is an array of Numerics and at least one other type' do
        let(:test_array) { [1, 2.2, 'this is a string', 1_024] }

        it 'returns false' do
          expect(matched_by?).to eq(false)
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
