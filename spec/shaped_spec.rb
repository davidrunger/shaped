# frozen_string_literal: true

RSpec.describe(Shaped) do
  it 'has a version number' do
    expect(Shaped::VERSION).not_to eq(nil)
  end

  describe '::Shape constructor method' do
    context 'when called with a single argument (a shape description)' do
      subject(:shape) { Shaped::Shape(shape_description) }

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

      context 'when called with a Class' do
        let(:shape_description) { Numeric }

        it 'returns an instance of Shaped::Shapes::Class' do
          expect(shape).to be_a(Shaped::Shapes::Class)
        end
      end

      context 'when called with an Integer' do
        let(:shape_description) { 2 }

        it 'returns an instance of Shaped::Shapes::Equality' do
          expect(shape).to be_a(Shaped::Shapes::Equality)
        end
      end
    end

    context 'when called with multiple arguments' do
      subject(:shape) { Shaped::Shape(*shape_descriptions) }

      context 'when called with two arguments' do
        let(:shape_descriptions) { [Integer, Float] }

        it 'returns an instance of Shaped::Shapes::Or' do
          expect(shape).to be_a(Shaped::Shapes::Or)
        end
      end

      context 'when called with three arguments' do
        let(:shape_descriptions) { [Integer, Float, BigDecimal] }

        it 'returns an instance of Shaped::Shapes::Or' do
          expect(shape).to be_a(Shaped::Shapes::Or)
        end
      end
    end
  end
end
