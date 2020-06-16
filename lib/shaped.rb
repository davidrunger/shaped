# frozen_string_literal: true

module Shaped ; end
module Shaped::Refinements ; end

require_relative './shaped/shape.rb'
require_relative './shaped/expectation_checking.rb'
Dir[File.dirname(__FILE__) + '/**/*.rb'].sort.each { |file| require file }

module Shaped
  # rubocop:disable  Naming/MethodName ("Use snake_case for method names.")
  def self.Array(shape_description)
    Shaped::Array.new(shape_description)
  end

  def self.Hash(shape_description)
    Shaped::Hash.new(shape_description)
  end
  # rubocop:enable  Naming/MethodName

  def self.lax_mode(&blk)
    original_strict_mode_value = Thread.current[:shaped_strict_mode]
    Thread.current[:shaped_strict_mode] = false

    blk.call

    Thread.current[:shaped_strict_mode] = original_strict_mode_value
  end

  def self.strict_mode(&blk)
    original_strict_mode_value = Thread.current[:shaped_strict_mode]
    Thread.current[:shaped_strict_mode] = true

    blk.call

    Thread.current[:shaped_strict_mode] = original_strict_mode_value
  end

  def self.strict_mode?
    Thread.current[:shaped_strict_mode] == true
  end

  def self.lax_mode?
    !strict_mode?
  end
end

class Shaped::InvalidShapeDescription < StandardError ; end
