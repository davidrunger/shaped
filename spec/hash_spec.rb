# frozen_string_literal: true

RSpec.describe Shaped::Hash do
  subject(:shaped_hash) { Shaped::Hash(shape_description) }

  let(:shape_description) { { email: String } }
  let(:test_hash) { { email: 'thomas.jefferson@gmail.com' } }

  describe '#initialize' do
    context 'when the shape description is a hash' do
      before { expect(shape_description).to be_a(Hash) }

      it 'does not raise an error' do
        expect { shaped_hash }.not_to raise_error
      end
    end

    context 'when the shape description is an array' do
      let(:shape_description) { [Numeric] }

      it 'raises an error' do
        expect { shaped_hash }.to raise_error(
          Shaped::InvalidShapeDescription,
          'A Shaped::Hash description must be a Hash (ex: `{ email: String }`).',
        )
      end
    end
  end

  describe '#matched_by?' do
    subject(:matched_by?) { shaped_hash.matched_by?(test_hash) }

    context 'when the shape description is `{ email: String }`' do
      let(:shape_description) { { email: String } }

      context 'when the test hash is an empty hash' do
        let(:test_hash) { {} }

        it 'returns false' do
          expect(matched_by?).to eq(false)
        end
      end

      context 'when the test hash matches the specified shape' do
        before { expect(test_hash).to eq(email: 'thomas.jefferson@gmail.com') }

        it 'returns true' do
          expect(matched_by?).to eq(true)
        end
      end

      context 'when the test hash does not match the specified shape' do
        let(:test_hash) { { email: 2_048 } }

        it 'returns false' do
          expect(matched_by?).to eq(false)
        end
      end
    end
  end

  describe '#match_failure_reason' do
    subject(:match_failure_reason) { shaped_hash.match_failure_reason(test_hash) }

    context 'when the test hash matches the shape description' do
      before { expect(shaped_hash).to be_matched_by(test_hash) }

      it 'returns nil' do
        expect(match_failure_reason).to eq(nil)
      end
    end

    context 'when the test hash does not match the shape description' do
      before { expect(shaped_hash).not_to be_matched_by(test_hash) }

      let(:test_hash) { { email: true } }

      it 'returns a Shaped::MatchFailureReason instance with the correct info' do
        expect(match_failure_reason).to be_a(Shaped::MatchFailureReason)
        expect(match_failure_reason.to_s).to eq(
          'Object at `email` is expected to be a String but was a TrueClass',
        )
      end
    end
  end
end
