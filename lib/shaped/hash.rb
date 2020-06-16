# frozen_string_literal: true

class Shaped::Hash
  def initialize(shape_description)
    unless shape_description.is_a?(Hash)
      raise(Shaped::InvalidShapeDescription, <<~ERROR.strip)
        A Shaped::Hash description must be a Hash (ex: `{ email: String }`).
      ERROR
    end

    @shape_description = shape_description
    @match_failure_reasons = {}
  end

  def matched_by?(hash)
    # avoid a memory leak from indefinitely adding to the @match_failure_reasons hash; we just want
    # to use it to memoize recently checked hashes (we'll somewhat arbitrarily go with 10 of them)
    if @match_failure_reasons.size > 10
      @match_failure_reasons = {}
    end

    if @match_failure_reasons.key?(hash)
      @match_failure_reasons[hash].nil?
    else
      all_attributes_match = true
      @shape_description.each do |key, expected_klass|
        value = hash[key]
        next if value.is_a?(expected_klass)

        all_attributes_match = false
        @match_failure_reasons[hash] =
          Shaped::MatchFailureReason.new(
            path: [key],
            expected: expected_klass,
            actual: value.class,
          )
        break
      end
      @match_failure_reasons[hash] = nil if all_attributes_match
      all_attributes_match
    end
  end

  def match_failure_reason(hash)
    if matched_by?(hash)
      nil
    else
      @match_failure_reasons[hash]
    end
  end
end
