# frozen_string_literal: true

RSpec.describe Shaped::Shapes::Method do
  subject(:method_shape) { Shaped::Shapes::Method.new(method_shape_description) }

  let(:method_shape_description) { :even? }
  let(:test_object) { 64 }

  describe '#initialize' do
    it 'does not raise an error' do
      expect { method_shape }.not_to raise_error
    end
  end

  describe '#matched_by?' do
    subject(:matched_by?) { method_shape.matched_by?(test_object) }

    context 'when the test object returns a truthy value when called with the specified method' do
      before { expect(test_object).to be_even }

      it 'returns true' do
        expect(matched_by?).to eq(true)
      end
    end

    context 'when the test object returns a falsy value when called with the specified method' do
      before { expect(test_object).not_to be_even }

      let(:test_object) { 71 }

      it 'returns false' do
        expect(matched_by?).to eq(false)
      end
    end
  end

  describe '#to_s' do
    subject(:to_s_method) { method_shape.to_s }

    it 'returns a string naming the method that must be matched' do
      expect(to_s_method).to eq('object returning truthy for #even?')
    end
  end
end
