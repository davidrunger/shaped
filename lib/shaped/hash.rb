# frozen_string_literal: true

class Shaped::Hash < Shaped::Shape
  include Shaped::ExpectationChecking
  include Shaped::ExpectedClassDescriptions

  def initialize(shape_description)
    unless shape_description.is_a?(Hash)
      raise(Shaped::InvalidShapeDescription, <<~ERROR.strip)
        A Shaped::Hash description must be a Hash (ex: `{ email: String }`).
      ERROR
    end

    @shape_description = shape_description
    @match_failure_reasons = {}
  end

  def descriptor
    printable_shape_description =
      @shape_description.map do |key, value|
        "#{key.inspect} => #{expected_class_descriptor(value)}"
      end.join(', ')

    "Hash shaped like { #{printable_shape_description} }"
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
  def matched_by?(hash, prepended_path: [])
    # avoid a memory leak from indefinitely adding to the @match_failure_reasons hash; we just want
    # to use it to memoize recently checked hashes (we'll somewhat arbitrarily go with 10 of them)
    if @match_failure_reasons.size > 10
      @match_failure_reasons = {}
    end

    if !hash.is_a?(Hash)
      @match_failure_reasons[hash] ||=
        Shaped::MatchFailureReason.new(
          path: prepended_path,
          expected_klass: Hash,
          actual_value: hash,
        )
      return
    end

    missing_keys = expected_keys - hash.keys
    if missing_keys.any?
      @match_failure_reasons[hash] ||=
        Shaped::MatchFailureReason.new(
          path: prepended_path + [missing_keys.first],
          expected_klass: @shape_description[missing_keys.first],
          actual_value: nil,
        )
      return false
    end

    if @match_failure_reasons.key?(hash)
      @match_failure_reasons[hash].nil?
    else
      all_attributes_match = true
      @shape_description.each do |key, expected_klass|
        value = hash[key]
        next if meets_expectation?(value, expected_klass, prepended_path: prepended_path + [key])

        all_attributes_match = false
        @match_failure_reasons[hash] =
          Shaped::MatchFailureReason.new(
            path: prepended_path + [key],
            expected_klass: expected_klass,
            actual_value: value,
          )
        break
      end
      @match_failure_reasons[hash] = nil if all_attributes_match
      all_attributes_match
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

  def match_failure_reason(hash)
    if matched_by?(hash)
      nil
    else
      @match_failure_reasons[hash]
    end
  end

  private

  def expected_keys
    @shape_description.keys
  end
end
