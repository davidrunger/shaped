# frozen_string_literal: true

class Shaped::Array < Shaped::Shape
  include Shaped::ExpectationChecking

  def initialize(shape_description)
    unless shape_description.size == 1
      raise(Shaped::InvalidShapeDescription, <<~ERROR.strip)
        A Shaped::Array description must be an array with exactly one element (ex: `[String]`).
      ERROR
    end

    unless shape_description.all? { _1.is_a?(Class) || _1.is_a?(Shaped::Shape) }
      raise(
        Shaped::InvalidShapeDescription,
        'The element of a Shaped::Array description must be a class (ex: `[String]`) ' \
        'or a Shaped::Shape (ex.: `[Shaped::Hash(email: String)]`).',
      )
    end

    @shape_klass = shape_description.first
    @match_failure_reasons = {}
  end

  def to_s
    "Array shaped like [#{@shape_klass}]"
  end

  def matched_by?(array, prepended_path: [])
    # avoid a memory leak from indefinitely adding to the @match_failure_reasons hash; we just want
    # to use it to memoize recently checked arrays (we'll somewhat arbitrarily go with 10 of them)
    if @match_failure_reasons.size > 10
      @match_failure_reasons = {}
    end

    if array.empty?
      Shaped.lax_mode?
    elsif @match_failure_reasons.key?(array)
      @match_failure_reasons[array].nil?
    else
      all_elements_match = true
      array.each_with_index do |element, index|
        next if meets_expectation?(element, @shape_klass, prepended_path: prepended_path + [index])

        all_elements_match = false
        @match_failure_reasons[array] ||=
          Shaped::MatchFailureReason.new(
            path: prepended_path + [index],
            expected_klass: @shape_klass,
            actual_value: element,
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
