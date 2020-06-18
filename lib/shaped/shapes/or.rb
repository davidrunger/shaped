# frozen_string_literal: true

class Shaped::Shapes::Or < Shaped::Shape
  def initialize(*shape_descriptions)
    if shape_descriptions.size <= 1
      raise(Shaped::InvalidShapeDescription, <<~ERROR.squish)
        A #{self.class} description must be a list of two or more shape descriptions.
      ERROR
    end

    @shapes = shape_descriptions.map { |description| Shaped::Shape(description) }
  end

  def matched_by?(object)
    @shapes.any? { |shape| shape.matched_by?(object) }
  end

  def to_s
    @shapes.map(&:to_s).join(', ')
  end
end
