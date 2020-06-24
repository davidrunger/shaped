# frozen_string_literal: true

class Shaped::Shapes::Method < Shaped::Shape
  def initialize(method_name)
    @method_name = method_name
  end

  def matched_by?(object)
    !!object.public_send(@method_name)
  end

  def to_s
    "object returning truthy for ##{@method_name}"
  end
end
