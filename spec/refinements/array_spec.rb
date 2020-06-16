# frozen_string_literal: true

RSpec.describe Shaped::Refinements::Array do
  using Shaped::Refinements::Array

  subject(:shaped_array) { Shaped::Array(shape_description) }

  describe '#has_shape?' do
    subject(:has_shape?) { test_array.has_shape?(shaped_array) }

    context 'when the shape description is `[Numeric]`' do
      let(:shape_description) { [Numeric] }

      context 'when the test array consists of solely Numerics' do
        subject(:test_array) { [1, 2.0, Rational(3, 4)] }

        it 'returns true' do
          expect(has_shape?).to eq(true)
        end
      end

      context 'when the test array has at least one non-Numeric element' do
        subject(:test_array) { [1, 2.0, 'not a number!', Rational(3, 4)] }

        it 'returns false' do
          expect(has_shape?).to eq(false)
        end
      end
    end
  end
end
