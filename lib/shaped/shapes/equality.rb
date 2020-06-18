# frozen_string_literal: true

class Shaped::Shapes::Equality < Shaped::Shape
  def initialize(shape_description)
    @expected_value = shape_description
  end

  def matched_by?(object)
    object == @expected_value
  end

  def to_s
    @expected_value.inspect
  end
end
