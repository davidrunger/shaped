# frozen_string_literal: true

module Shaped ; end
module Shaped::Shapes ; end

require 'active_support/all'
require 'active_model'
require_relative './shaped/shape.rb'
Dir[File.dirname(__FILE__) + '/**/*.rb'].sort.each { |file| require file }

module Shaped
  # rubocop:disable Naming/MethodName, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def self.Shape(*shape_descriptions)
    validation_options = shape_descriptions.extract_options!
    if shape_descriptions.size >= 2
      Shaped::Shapes::Or.new(*shape_descriptions, validation_options)
    else
      # If the shape_descriptions argument list was just one hash, then `extract_options!` would
      # have removed it, making `shape_descriptions` an empty array, so we need to "restore" the
      # "validation options" to their actual role of a Hash `shape_description` here.
      shape_description =
        case
        when shape_descriptions.empty? && validation_options.is_a?(Hash)
          validation_options
        else
          shape_descriptions.first
        end

      case shape_description
      when Hash then Shaped::Shapes::Hash.new(shape_description)
      when Array then Shaped::Shapes::Array.new(shape_description)
      when Class then Shaped::Shapes::Class.new(shape_description, validation_options)
      else
        if shape_description.respond_to?(:call)
          Shaped::Shapes::Callable.new(shape_description)
        else
          Shaped::Shapes::Equality.new(shape_description)
        end
      end
    end
  end
  # rubocop:enable Naming/MethodName, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end

class Shaped::InvalidShapeDescription < StandardError ; end
