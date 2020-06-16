# frozen_string_literal: true

module Shaped::Refinements::Array
  refine ::Array do
    # rubocop:disable Naming/PredicateName (rubocop wants us to name this method just `shape?`)
    def has_shape?(shaped_array)
      shaped_array.matched_by?(self)
    end
    # rubocop:enable Naming/PredicateName
  end
end
