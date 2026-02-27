# frozen_string_literal: true

class Shaped::Shapes::All < Shaped::Shape
  def initialize(*shape_descriptions)
    validation_options = shape_descriptions.extract_options!
    if shape_descriptions.size <= 1
      raise(Shaped::InvalidShapeDescription, <<~ERROR.squish)
        A #{self.class} description must be a list of two or more shape descriptions.
      ERROR
    end

    @shapes =
      shape_descriptions.map do |description|
        Shaped::Shape(description, validation_options)
      end
  end

  def matched_by?(object)
    @shapes.all? { |shape| shape.matched_by?(object) }
  end

  def to_s
    @shapes.join(' AND ')
  end
end
