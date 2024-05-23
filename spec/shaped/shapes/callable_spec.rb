# frozen_string_literal: true

RSpec.describe Shaped::Shapes::Callable do
  subject(:callable_shape) { Shaped::Shapes::Callable.new(callable_shape_description) }

  # rubocop:disable Style/SymbolProc
  let(:callable_shape_description) { ->(object) { object.even? } }
  # rubocop:enable Style/SymbolProc
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
    subject(:to_s_method) { callable_shape.to_s }

    context 'when the callable is a `Method`' do
      def number_is_greater_than_thirty?(number)
        number > 30
      end

      let(:callable_shape_description) { method(:number_is_greater_than_thirty?) }

      it 'returns a string mentioning the line where the callable is defined' do
        expect(to_s_method).
          to match(%r{Method defined at .*/spec/shaped/shapes/callable_spec.rb:\d+})
      end
    end

    context 'when the callable is a proc' do
      before { expect(callable_shape_description).to be_a(Proc) }

      it 'returns a string mentioning the line where the callable is defined' do
        expect(to_s_method).
          to match(%r{Proc test defined at .*/spec/shaped/shapes/callable_spec.rb:\d+})
      end
    end

    context 'when the callable is a proc without a source location' do
      let(:callable_shape_description) { lambda(&:even?) }

      it 'returns a string mentioning a proc defined at an unknown location' do
        expect(to_s_method).
          to match(%r{Proc test defined at unknown location})
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
        expect(to_s_method).
          to match(%r{#call test defined at .*/spec/shaped/shapes/callable_spec.rb:\d+})
      end
    end
  end
end
