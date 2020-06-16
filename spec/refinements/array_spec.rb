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
end
