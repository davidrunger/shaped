# frozen_string_literal: true

RSpec.describe Shaped::Shapes::Callable do
  subject(:callable_shape) { Shaped::Shapes::Callable.new(callable_shape_description) }

  let(:callable_shape_description) { ->(object) { object.even? } }
  let(:test_object) { 32 }

  describe '#initialize' do
    it 'does not raise an error' do
      expect { callable_shape }.not_to raise_error
    end
  end

  describe '#matched_by?' do
    subject(:matched_by?) { callable_shape.matched_by?(test_object) }

    context 'when the callable returns a truthy value when called with the test object' do
      before do
        expect(test_object).to be_even
        expect(callable_shape_description.call(test_object)).to eq(true)
      end

      it 'returns true' do
        expect(matched_by?).to eq(true)
      end
    end

    context 'when the callable returns a falsy value when called with the test object' do
      before do
        expect(test_object).not_to be_even
        expect(callable_shape_description.call(test_object)).to eq(false)
      end

      let(:test_object) { 31 }

      it 'returns false' do
        expect(matched_by?).to eq(false)
      end
    end
  end

  describe '#to_s' do
    subject(:to_s) { callable_shape.to_s }

    context 'when the callable is a proc' do
      let(:callable_shape_description) { ->(object) { object.even? } }

      it 'returns a string mentioning the line where the callable is defined' do
        expect(to_s).to match(%r{Proc test defined at .*/spec/shapes/callable_spec.rb:\d+})
      end
    end

    context 'when the callable is an instance of a class' do
      before do
        stub_const(
          'EvenParityTester',
          Class.new do
            def call(number)
              @number = number
              number_is_even?
            end

            private

            def number_is_even?
              @number.even?
            end
          end,
        )
      end

      let(:callable_shape_description) { EvenParityTester.new }

      it 'returns a string mentioning the line where the callable is defined' do
        expect(to_s).to match(%r{#call test defined at .*/spec/shapes/callable_spec.rb:59})
      end
    end
  end
end
