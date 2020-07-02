# frozen_string_literal: true

RSpec.describe Shaped::Shapes::Class do
  context 'when the shape definition is just a class' do
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

  context 'when the shape definition is a Class plus one or more validations' do
    subject(:class_shape) do
      Shaped::Shapes::Class.new(
        Numeric,
        numericality: {
          greater_than_or_equal_to: min_value,
          less_than_or_equal_to: max_value,
        },
      )
    end

    let(:min_value) { 0 }
    let(:max_value) { 1_000 }
    let(:test_object) { 86.4 }

    describe '#initialize' do
      it 'does not raise an error' do
        expect { class_shape }.not_to raise_error
      end
    end

    describe '#matched_by?' do
      subject(:matched_by?) { class_shape.matched_by?(test_object) }

      context 'when the test object meets the specified validation(s)' do
        before do
          expect(test_object).to be >= min_value
          expect(test_object).to be <= max_value
        end

        let(:test_object) { 299 }

        it 'returns true' do
          expect(matched_by?).to eq(true)
        end
      end

      context 'when the test object does not meet one of the specified validation(s)' do
        before { expect(test_object).not_to be >= min_value }

        let(:test_object) { -203 }

        it 'returns false' do
          expect(matched_by?).to eq(false)
        end
      end

      context 'when the test object does not meet another one of the specified validation(s)' do
        before { expect(test_object).not_to be <= max_value }

        let(:test_object) { 1_654 }

        it 'returns false' do
          expect(matched_by?).to eq(false)
        end
      end
    end

    describe '#to_s' do
      subject(:to_s) { class_shape.to_s }

      it 'returns a readably formatted description of the expected class and validations' do
        expect(to_s).to eq(<<~TO_S.squish)
          Numeric validating {:numericality=>{:greater_than_or_equal_to=>0,
          :less_than_or_equal_to=>1000}}
        TO_S
      end
    end
  end
end
