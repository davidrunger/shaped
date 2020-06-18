# frozen_string_literal: true

module Shaped ; end
module Shaped::Shapes ; end

require 'active_support/all'
require_relative './shaped/shape.rb'
Dir[File.dirname(__FILE__) + '/**/*.rb'].sort.each { |file| require file }

module Shaped
  # rubocop:disable Naming/MethodName
  def self.Shape(*shape_descriptions)
    if shape_descriptions.size >= 2
      Shaped::Shapes::Or.new(*shape_descriptions)
    else
      shape_description = shape_descriptions.first
      case shape_description
      when Hash then Shaped::Shapes::Hash.new(shape_description)
      when Array then Shaped::Shapes::Array.new(shape_description)
      when Class then Shaped::Shapes::Class.new(shape_description)
      else Shaped::Shapes::Equality.new(shape_description)
      end
    end
  end
  # rubocop:enable Naming/MethodName
end

class Shaped::InvalidShapeDescription < StandardError ; end
