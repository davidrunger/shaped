# frozen_string_literal: true

RSpec.describe Shaped::Shapes::Any do
  subject(:any_shape) { Shaped::Shapes::Any.new(*any_shape_descriptions) }

  let(:any_shape_descriptions) { [Numeric, String] }
  let(:test_object) { 'David Runger' }

  describe '#initialize' do
    context 'when initialized with a list of multiple classes' do
      let(:any_shape_descriptions) { [Numeric, String] }

      it 'does not raise an error' do
        expect { any_shape }.not_to raise_error
      end
    end

    context 'when initialized with a list of multiple array descriptions' do
      let(:any_shape_descriptions) { [[Numeric], [String]] }

      it 'does not raise an error' do
        expect { any_shape }.not_to raise_error
      end

      describe '#matched_by?' do
        subject(:matched_by?) { any_shape.matched_by?(test_object) }

        context 'when the test object is an array of only Numerics' do
          let(:test_object) { [1, 2.0, Rational(3, 4)] }

          it 'returns true' do
            expect(matched_by?).to eq(true)
          end
        end

        context 'when the test object is an array of only Strings' do
          let(:test_object) { ['one', 'two point zero', 'three fourths'] }

          it 'returns true' do
            expect(matched_by?).to eq(true)
          end
        end

        context 'when the test object is an array that mixes Numerics and Strings' do
          let(:test_object) { [1.0, 'two point zero', 0.75] }

          it 'returns false' do
            expect(matched_by?).to eq(false)
          end
        end
      end
    end

    context 'when initialized with a single argument' do
      let(:any_shape_descriptions) { [Numeric] }

      it 'raises an error' do
        expect { any_shape }.to raise_error(Shaped::InvalidShapeDescription, <<~ERROR.squish)
          A Shaped::Shapes::Any description must be a list of two or more shape descriptions.
        ERROR
      end
    end
  end

  describe '#matched_by?' do
    subject(:matched_by?) { any_shape.matched_by?(test_object) }

    context 'when the test object satisfies one of the shape descriptions' do
      before { expect(test_object).to be_a(any_shape_descriptions.second) }

      it 'returns true' do
        expect(matched_by?).to eq(true)
      end
    end

    context 'when the test object does not satisfy any of the shape descriptions' do
      before do
        any_shape_descriptions.each do |klass|
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
    subject(:to_s_method) { any_shape.to_s }

    it 'returns a readably formatted description of the list of allowed shapes' do
      expect(to_s_method).to eq('Numeric OR String')
    end
  end
end
