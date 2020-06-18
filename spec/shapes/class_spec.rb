# frozen_string_literal: true

RSpec.describe Shaped::Shapes::Class do
  subject(:class_shape) { Shaped::Shapes::Class.new(class_shape_description) }

  let(:class_shape_description) { Numeric }
  let(:test_object) { 2.48 }

  describe '#initialize' do
    context 'when the shape description is a Class' do
      before { expect(class_shape_description).to be_a(Class) }

      it 'does not raise an error' do
        expect { class_shape }.not_to raise_error
      end
    end

    context 'when the shape description is a Hash' do
      let(:class_shape_description) { { name: String } }

      it 'raises an error' do
        expect { class_shape }.to raise_error(Shaped::InvalidShapeDescription, <<~ERROR.squish)
          A Shaped::Shapes::Class description must be a Class.
        ERROR
      end
    end
  end

  describe '#matched_by?' do
    subject(:matched_by?) { class_shape.matched_by?(test_object) }

    context 'when the shape description is `Numeric`' do
      let(:class_shape_description) { Numeric }

      context 'when the test object is a Numeric' do
        let(:test_object) { 299 }

        it 'returns true' do
          expect(matched_by?).to eq(true)
        end
      end

      context 'when the test object is not an instance of the specified class' do
        let(:test_object) { 'this is not a Numeric (it is a String)' }

        it 'returns false' do
          expect(matched_by?).to eq(false)
        end
      end
    end
  end

  describe '#to_s' do
    subject(:to_s) { class_shape.to_s }

    it 'returns a readably formatted description of the expected class' do
      expect(to_s).to eq('Numeric')
    end
  end
end
