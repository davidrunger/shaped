# frozen_string_literal: true

module Shaped::ExpectedClassDescriptions
  private

  def expected_class_descriptor(expected_klass)
    if expected_klass.is_a?(Shaped::Shape)
      expected_klass.descriptor
    else
      expected_klass.name
    end
  end
end
