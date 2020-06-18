# frozen_string_literal: true

RSpec.describe Shaped::Shapes::Or do
  subject(:or_shape) { Shaped::Shapes::Or.new(*or_shape_descriptions) }

  let(:or_shape_descriptions) { [Numeric, String] }
  let(:test_object) { 'David Runger' }

  describe '#initialize' do
    context 'when initialized with a list of multiple classes' do
      let(:or_shape_descriptions) { [Numeric, String] }

      it 'does not raise an error' do
        expect { or_shape }.not_to raise_error
      end
    end

    context 'when initialized with a single argument' do
      let(:or_shape_descriptions) { [Numeric] }

      it 'raises an error' do
        expect { or_shape }.to raise_error(Shaped::InvalidShapeDescription, <<~ERROR.squish)
          A Shaped::Shapes::Or description must be a list of two or more shape descriptions.
        ERROR
      end
    end
  end

  describe '#matched_by?' do
    subject(:matched_by?) { or_shape.matched_by?(test_object) }

    context 'when the test object satisfies one of the shape descriptions' do
      before { expect(test_object).to be_a(or_shape_descriptions.second) }

      it 'returns true' do
        expect(matched_by?).to eq(true)
      end
    end

    context 'when the test object does not satisfy any of the shape descriptions' do
      before do
        or_shape_descriptions.each do |klass|
          expect(test_object).not_to be_a(klass)
        end
      end

      let(:test_object) { { id: 931, name: 'Justin Crum' } }

      it 'returns false' do
        expect(matched_by?).to eq(false)
      end
    end
  end

  describe '#to_s' do
    subject(:to_s) { or_shape.to_s }

    it 'returns a readably formatted description of the list of allowed shapes' do
      expect(to_s).to eq('Numeric, String')
    end
  end
end
