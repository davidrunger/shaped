# frozen_string_literal: true

class Shaped::Array
  def initialize(shape_description)
    unless shape_description.size == 1
      raise(Shaped::InvalidShapeDescription, <<~ERROR.strip)
        A Shaped::Array description must be an array with exactly one element (ex: `[String]`).
      ERROR
    end

    unless shape_description.all? { _1.is_a?(Class) }
      raise(Shaped::InvalidShapeDescription, <<~ERROR.strip)
        The element of a Shaped::Array description must be a class (ex: `[String]`).
      ERROR
    end

    @shape_klass = shape_description.first
  end

  def matched_by?(array)
    if array.empty?
      Shaped.lax_mode?
    else
      array.all? { _1.is_a?(@shape_klass) }
    end
  end
end
