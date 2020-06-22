# frozen_string_literal: true

class Shaped::Shapes::Hash < Shaped::Shape
  def initialize(shape_description)
    unless shape_description.is_a?(Hash)
      raise(Shaped::InvalidShapeDescription, "A #{self.class} description must be a Hash.")
    end

    @hash_description = shape_description.transform_values { |value| Shaped::Shape(value) }
  end

  def matched_by?(hash)
    return false if !hash.is_a?(Hash)

    @hash_description.all? do |key, expected_value_shape|
      expected_value_shape.matched_by?(hash[key])
    end
  end

  def to_s
    printable_shape_description =
      @hash_description.map do |key, value|
        "#{key.inspect} => #{value}"
      end.join(', ')

    "{ #{printable_shape_description} }"
  end
end
