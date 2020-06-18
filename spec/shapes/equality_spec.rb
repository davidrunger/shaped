# frozen_string_literal: true

RSpec.describe Shaped::Shapes::Equality do
  subject(:equality_shape) { Shaped::Shapes::Equality.new(equality_shape_description) }

  let(:equality_shape_description) { 'David Runger' }
  let(:test_object) { 'David Runger' }

  describe '#initialize' do
    it 'does not raise an error' do
      expect { equality_shape }.not_to raise_error
    end
  end

  describe '#matched_by?' do
    subject(:matched_by?) { equality_shape.matched_by?(test_object) }

    context 'when the test object equals the shape description' do
      before { expect(test_object).to eq(equality_shape_description) }

      it 'returns true' do
        expect(matched_by?).to eq(true)
      end
    end

    context 'when the test object does not equal the shape description' do
      before { expect(test_object).not_to eq(equality_shape_description) }

      let(:test_object) { 'Johnny Cash' }

      it 'returns false' do
        expect(matched_by?).to eq(false)
      end
    end
  end

  describe '#to_s' do
    subject(:to_s) { equality_shape.to_s }

    it 'returns a readably formatted description of the expected value' do
      expect(to_s).to eq('"David Runger"')
    end
  end
end
