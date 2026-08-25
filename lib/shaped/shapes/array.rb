# frozen_string_literal: true

class Shaped::Shapes::Array < Shaped::Shape
  def initialize(shape_description)
    if !shape_description.is_a?(Array)
      raise(Shaped::InvalidShapeDescription, "A #{self.class} description must be an array.")
    end

    @element_test = Shaped::Shape(*shape_description)
  end

  def matched_by?(array)
    if array.is_a?(Array)
      array.all? { |element| @element_test.matched_by?(element) }
    else
      false
    end
  end

  def to_s
    "[#{@element_test}]"
  end
end
