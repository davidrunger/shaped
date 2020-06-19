# frozen_string_literal: true

module Shaped ; end
module Shaped::Shapes ; end

require 'active_support/all'
require 'active_model'
require_relative './shaped/shape.rb'
Dir[File.dirname(__FILE__) + '/**/*.rb'].sort.each { |file| require file }

module Shaped
  # rubocop:disable Naming/MethodName
  def self.Shape(*shape_descriptions)
    validation_options = shape_descriptions.extract_options!
    if shape_descriptions.size >= 2
      Shaped::Shapes::Or.new(*shape_descriptions, validation_options)
    else
      # If the shape_descriptions argument list was just one hash, then `extract_options!` would
      # have removed it, making `shape_descriptions` an empty array, so we need to "restore" the
      # "validation options" to their actual role of a Hash `shape_description` here.
      shape_description = shape_descriptions.first || validation_options

      case shape_description
      when Hash then Shaped::Shapes::Hash.new(shape_description)
      when Array then Shaped::Shapes::Array.new(shape_description)
      when Class then Shaped::Shapes::Class.new(shape_description, validation_options)
      else Shaped::Shapes::Equality.new(shape_description)
      end
    end
  end
  # rubocop:enable Naming/MethodName
end

class Shaped::InvalidShapeDescription < StandardError ; end
