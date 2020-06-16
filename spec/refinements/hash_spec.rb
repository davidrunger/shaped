# frozen_string_literal: true

RSpec.describe Shaped::Refinements::Hash do
  using Shaped::Refinements::Hash

  subject(:shaped_hash) { Shaped::Hash(shape_description) }

  let(:shape_description) { { email: String } }
  let(:test_hash) { { email: 'john.locke@gmail.com' } }

  describe '#has_shape?' do
    subject(:has_shape?) { test_hash.has_shape?(shaped_hash) }

    context 'when the shape description is `{ email: String }`' do
      before { expect(shape_description).to eq(email: String) }

      context 'when the test hash matches the specified shape' do
        before { expect(test_hash).to eq(email: 'john.locke@gmail.com') }

        it 'returns true' do
          expect(has_shape?).to eq(true)
        end
      end

      context 'when the test hash does not match the specified shape' do
        let(:test_hash) { { email: { personal: 'john.locke@gmail.com' } } }

        it 'returns false' do
          expect(has_shape?).to eq(false)
        end
      end
    end
  end
end
