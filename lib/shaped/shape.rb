# frozen_string_literal: true

class Shaped::Shape
  def initialize(_shape_description)
    raise("`#initialize(shape_description)` must be implemented for #{self.class}!")
  end

  def matched_by?(_tested_object)
    raise("`#matched_by?(tested_object)` must be implemented for #{self.class}!")
  end

  def to_s
    raise("`#to_s` must be implemented for #{self.class}!")
  end
end
