# frozen_string_literal: true

RSpec.describe Shaped::Shapes::Hash do
  subject(:hash_shape) { Shaped::Shapes::Hash.new(hash_shape_description) }

  let(:hash_shape_description) { { email: String } }
  let(:test_hash) { { email: 'thomas.jefferson@gmail.com' } }

  describe '#initialize' do
    context 'when the shape description is a hash' do
      before { expect(hash_shape_description).to be_a(Hash) }

      it 'does not raise an error' do
        expect { hash_shape }.not_to raise_error
      end
    end

    context 'when the shape description is an array' do
      let(:hash_shape_description) { [Numeric] }

      it 'raises an error' do
        expect { hash_shape }.to raise_error(Shaped::InvalidShapeDescription, <<~ERROR.squish)
          A Shaped::Shapes::Hash description must be a Hash.
        ERROR
      end
    end
  end

  describe '#matched_by?' do
    subject(:matched_by?) { hash_shape.matched_by?(test_hash) }

    context 'when the shape description is `{ email: String }`' do
      let(:hash_shape_description) { { email: String } }

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

  describe '#to_s' do
    subject(:to_s) { hash_shape.to_s }

    it 'returns a readably formatted description of the expected hash shape' do
      expect(to_s).to eq('{ :email => String }')
    end
  end
end
