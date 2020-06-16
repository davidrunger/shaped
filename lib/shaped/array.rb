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
    @match_failure_reasons = {}
  end

  def matched_by?(array)
    if array.empty?
      Shaped.lax_mode?
    elsif @match_failure_reasons.key?(array)
      @match_failure_reasons[array].nil?
    else
      all_elements_match = true
      array.each_with_index do |element, index|
        next if element.is_a?(@shape_klass)

        all_elements_match = false
        @match_failure_reasons[array] =
          Shaped::MatchFailureReason.new(
            path: [index],
            expected: @shape_klass,
            actual: element.class,
          )
        break
      end
      @match_failure_reasons[array] = nil if all_elements_match
      all_elements_match
    end
  end

  def match_failure_reason(array)
    if matched_by?(array)
      nil
    else
      @match_failure_reasons[array]
    end
  end
end
