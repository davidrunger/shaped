# frozen_string_literal: true

module Shaped::Refinements::Hash
  refine ::Hash do
    # rubocop:disable Naming/PredicateName (rubocop wants us to name this method just `shape?`)
    def has_shape?(shaped_hash)
      shaped_hash.matched_by?(self)
    end
    # rubocop:enable Naming/PredicateName
  end
end
