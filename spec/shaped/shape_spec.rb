# frozen_string_literal: true

RSpec.describe Shaped::Shape do
  subject(:shape) { Shaped::Shape.allocate }

  describe '#initialize' do
    subject(:instantiate_shape) { Shaped::Shape.new('dummy shape description') }

    it 'raises an error' do
      expect { instantiate_shape }.to raise_error(<<~ERROR.squish)
        `#initialize(shape_description)` must be implemented for Shaped::Shape!
      ERROR
    end
  end

  describe '#matched_by?' do
    subject(:matched_by?) { shape.matched_by?(nil) }

    it 'raises an error' do
      expect { matched_by? }.to raise_error(<<~ERROR.squish)
        `#matched_by?(tested_object)` must be implemented for Shaped::Shape!
      ERROR
    end
  end

  describe '#to_s' do
    subject(:to_s) { shape.to_s }

    it 'raises an error' do
      expect { to_s }.to raise_error(<<~ERROR.squish)
        `#to_s` must be implemented for Shaped::Shape!
      ERROR
    end
  end
end
