# frozen_string_literal: true

class Shaped::Shapes::Class < Shaped::Shape
  def initialize(expected_klass, validations = {})
    if !expected_klass.is_a?(Class)
      raise(Shaped::InvalidShapeDescription, "A #{self.class} description must be a Class.")
    end

    @expected_klass = expected_klass
    @validations = validations
    @validator_klass = validator_klass(validations)
  end

  def matched_by?(object)
    object.is_a?(@expected_klass) && validations_satisfied?(object)
  end

  def to_s
    if @validations.empty?
      @expected_klass.name
    else
      "#{@expected_klass} validating #{@validations}"
    end
  end

  private

  def validator_klass(validations)
    return nil if validations.empty?

    Class.new do
      include ActiveModel::Validations

      attr_accessor :value

      validates :value, validations

      class << self
        # ActiveModel requires the class to have a `name`
        def name
          'Shaped::Shapes::Class::AnonymousValidator'
        end
      end
    end
  end

  def validations_satisfied?(object)
    return true if @validator_klass.nil?

    validator_instance = @validator_klass.new
    validator_instance.value = object
    validator_instance.valid?
  end
end
