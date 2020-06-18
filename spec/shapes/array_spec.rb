# frozen_string_literal: true

RSpec.describe Shaped::Shapes::Array do
  subject(:array_shape) { Shaped::Shapes::Array.new(array_shape_description) }

  let(:array_shape_description) { [Numeric] }
  let(:test_array) { [1, 2.2, 1_024] }

  describe '#initialize' do
    context 'when the shape description is an array of one class' do
      let(:array_shape_description) { [String] }

      it 'does not raise an error' do
        expect { array_shape }.not_to raise_error
      end
    end

    context 'when the shape description is an array of one non-class element' do
      let(:array_shape_description) { ['two'] }

      it 'does not raise an error' do
        expect { array_shape }.not_to raise_error
      end
    end

    context 'when the shape description is an array of multiple classes' do
      let(:array_shape_description) { [Integer, String] }

      it 'does not raise an error' do
        expect { array_shape }.not_to raise_error
      end
    end

    context 'when the shape description is not an array' do
      let(:array_shape_description) { Numeric }

      it 'raises an error' do
        expect { array_shape }.to raise_error(Shaped::InvalidShapeDescription, <<~ERROR.squish)
          A Shaped::Shapes::Array description must be an array.
        ERROR
      end
    end
  end

  describe '#matched_by?' do
    subject(:matched_by?) { array_shape.matched_by?(test_array) }

    context 'when the shape description is `[Numeric]`' do
      before { expect(array_shape_description).to eq([Numeric]) }

      context 'when the test array is an empty array' do
        let(:test_array) { [] }

        it 'returns true' do
          expect(matched_by?).to eq(true)
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

      context 'when the "test array" is not an array' do
        let(:test_array) { 20 }

        it 'returns false' do
          expect(matched_by?).to eq(false)
        end
      end
    end
  end

  describe '#to_s' do
    subject(:to_s) { array_shape.to_s }

    it 'returns a readably formatted description of the expected array shape' do
      expect(to_s).to eq('[Numeric]')
    end

    context 'when the array shape is a list of multiple classes' do
      subject(:array_shape) { Shaped::Shapes::Array.new([String, Numeric]) }

      it 'returns a readably formatted description of the expected array shape' do
        expect(to_s).to eq('[String, Numeric]')
      end
    end

    context 'when the array shape is a list of multiple objects' do
      subject(:array_shape) { Shaped::Shapes::Array.new(%w[two four six]) }

      it 'returns a readably formatted description of the allowed object values' do
        expect(to_s).to eq('["two", "four", "six"]')
      end
    end
  end
end
