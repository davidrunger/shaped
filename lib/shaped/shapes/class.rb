# frozen_string_literal: true

class Shaped::Shapes::Class < Shaped::Shape
  def initialize(shape_description)
    if !shape_description.is_a?(Class)
      raise(Shaped::InvalidShapeDescription, "A #{self.class} description must be a Class.")
    end

    @expected_klass = shape_description
  end

  def matched_by?(object)
    object.is_a?(@expected_klass)
  end

  def to_s
    @expected_klass.name
  end
end
