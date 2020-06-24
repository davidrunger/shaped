# frozen_string_literal: true

RSpec.describe(Shaped) do
  it 'has a version number' do
    expect(Shaped::VERSION).not_to eq(nil)
  end

  describe '::Shape constructor method' do
    context 'when called with a single argument (a shape description)' do
      subject(:shape) { Shaped::Shape(shape_description) }

      context 'when called with a Shaped::Shape' do
        let(:shape_description) { Shaped::Shape(Numeric, nil) }

        it 'returns the shape_description itself' do
          expect(shape).to eq(shape_description)
        end
      end

      context 'when called with a Hash' do
        let(:shape_description) { { email: String } }

        it 'returns an instance of Shaped::Shapes::Hash' do
          expect(shape).to be_a(Shaped::Shapes::Hash)
        end
      end

      context 'when called with an Array' do
        let(:shape_description) { [Numeric] }

        it 'returns an instance of Shaped::Shapes::Array' do
          expect(shape).to be_a(Shaped::Shapes::Array)
        end
      end

      context 'when called with a Symbol' do
        let(:shape_description) { :valid? }

        it 'returns an instance of Shaped::Shapes::Method' do
          expect(shape).to be_a(Shaped::Shapes::Method)
        end
      end

      context 'when called with a Class' do
        let(:shape_description) { Numeric }

        it 'returns an instance of Shaped::Shapes::Class' do
          expect(shape).to be_a(Shaped::Shapes::Class)
        end
      end

      context 'when called with an object that responds to #call (e.g. a Proc)' do
        let(:shape_description) { ->(object) { object.even? } }

        it 'returns an instance of Shaped::Shapes::Callable' do
          expect(shape).to be_a(Shaped::Shapes::Callable)
        end
      end

      context 'when called with an Integer' do
        let(:shape_description) { 2 }

        it 'returns an instance of Shaped::Shapes::Equality' do
          expect(shape).to be_a(Shaped::Shapes::Equality)
        end
      end

      context 'when called with `false`' do
        let(:shape_description) { false }

        it 'returns an instance of Shaped::Shapes::Equality' do
          expect(shape).to be_a(Shaped::Shapes::Equality)
        end

        describe 'the returned shape' do
          subject(:matched_by?) { shape.matched_by?(test_object) }

          context 'when tested against `false`' do
            let(:test_object) { false }

            it 'matches' do
              expect(matched_by?).to eq(true)
            end
          end

          context 'when tested against `nil`' do
            let(:test_object) { nil }

            it 'does not match' do
              expect(matched_by?).to eq(false)
            end
          end

          context 'when tested against `true`' do
            let(:test_object) { true }

            it 'does not match' do
              expect(matched_by?).to eq(false)
            end
          end
        end
      end
    end

    context 'when called with multiple arguments' do
      subject(:shape) { Shaped::Shape(*shape_descriptions) }

      context 'when called with two arguments' do
        let(:shape_descriptions) { [Integer, Float] }

        it 'returns an instance of Shaped::Shapes::Any' do
          expect(shape).to be_a(Shaped::Shapes::Any)
        end
      end

      context 'when called with three arguments' do
        let(:shape_descriptions) { [Integer, Float, BigDecimal] }

        it 'returns an instance of Shaped::Shapes::Any' do
          expect(shape).to be_a(Shaped::Shapes::Any)
        end
      end
    end

    context 'when called with one class plus ActiveModel validation options' do
      subject(:shape) { Shaped::Shape(Numeric, numericality: { greater_than: 21 }) }

      it 'returns an instance of Shaped::Shapes::Class' do
        expect(shape).to be_a(Shaped::Shapes::Class)
      end
    end

    context 'when called with two classes plus ActiveModel validation options' do
      subject(:shape) { Shaped::Shape(Float, Integer, numericality: { greater_than: min_value }) }

      let(:min_value) { 21 }

      it 'returns an instance of Shaped::Shapes::Any' do
        expect(shape).to be_a(Shaped::Shapes::Any)
      end

      describe '#matched_by? for the returned `Any` shape' do
        subject(:matched_by?) { shape.matched_by?(test_object) }

        context 'when the test object is an instance of the first listed allowed class' do
          before { expect(test_object).to be_a(Float) }

          context 'when the test object meets the ActiveModel validation' do
            before { expect(test_object).to be > min_value }

            let(:test_object) { 22.2 }

            it 'returns true' do
              expect(matched_by?).to eq(true)
            end
          end

          context 'when the test object does not meet the ActiveModel validation' do
            before { expect(test_object).not_to be > min_value }

            let(:test_object) { 18.9 }

            it 'returns false' do
              expect(matched_by?).to eq(false)
            end
          end
        end

        context 'when the test object is an instance of the second listed allowed class' do
          before { expect(test_object).to be_a(Integer) }

          context 'when the test object meets the ActiveModel validation' do
            before { expect(test_object).to be > min_value }

            let(:test_object) { 30 }

            it 'returns true' do
              expect(matched_by?).to eq(true)
            end
          end

          context 'when the test object does not meet the ActiveModel validation' do
            before { expect(test_object).not_to be > min_value }

            let(:test_object) { 10 }

            it 'returns false' do
              expect(matched_by?).to eq(false)
            end
          end
        end
      end

      describe '#to_s for the returned `Any` shape' do
        subject(:to_s) { shape.to_s }

        it 'returns a good description of the shape' do
          expect(to_s).to eq(<<~TO_S.squish)
            Float validating {:numericality=>{:greater_than=>21}} OR Integer validating
            {:numericality=>{:greater_than=>21}}
          TO_S
        end
      end
    end
  end
end
