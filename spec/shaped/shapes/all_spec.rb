# frozen_string_literal: true

RSpec.describe Shaped::Shapes::All do
  subject(:all_shape) { Shaped::Shapes::All.new(*all_shape_descriptions) }

  let(:all_shape_descriptions) { [Numeric, :even?] }
  let(:test_object) { 88 }

  describe '#initialize' do
    context 'when initialized with a list of multiple classes' do
      before { expect(all_shape_descriptions.size).to be >= 2 }

      it 'does not raise an error' do
        expect { all_shape }.not_to raise_error
      end
    end

    context 'when initialized with a single argument' do
      let(:all_shape_descriptions) { [Numeric] }

      it 'raises an error' do
        expect { all_shape }.to raise_error(Shaped::InvalidShapeDescription, <<~ERROR.squish)
          A Shaped::Shapes::All description must be a list of two or more shape descriptions.
        ERROR
      end
    end
  end

  describe '#matched_by?' do
    subject(:matched_by?) { all_shape.matched_by?(test_object) }

    context 'when the test object satisfies all of the sub-shape descriptions' do
      before do
        expect(test_object).to be_a(all_shape_descriptions.first)
        expect(test_object.public_send(all_shape_descriptions.second)).to eq(true)
      end

      it 'returns true' do
        expect(matched_by?).to eq(true)
      end
    end

    context 'when the test object does not satisfy all of the shape descriptions' do
      let(:test_object) { 33 }

      before do
        expect(test_object).to be_a(all_shape_descriptions.first) # matched
        expect(test_object.public_send(all_shape_descriptions.second)).to eq(false) # not matched
      end

      it 'returns false' do
        expect(matched_by?).to eq(false)
      end
    end
  end

  describe '#to_s' do
    subject(:to_s_method) { all_shape.to_s }

    it 'returns a readably formatted description of the list of required shapes' do
      expect(to_s_method).to eq('Numeric AND object returning truthy for #even?')
    end
  end
end
