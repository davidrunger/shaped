# frozen_string_literal: true

module Shaped::ExpectationChecking
  private

  def meets_expectation?(value, expected_klass, prepended_path: [])
    if expected_klass.is_a?(Class)
      value.is_a?(expected_klass)
    elsif expected_klass.is_a?(Shaped::Shape)
      expected_klass.matched_by?(value, prepended_path: prepended_path)
    else
      raise('Bad expected class!')
    end
  end
end
