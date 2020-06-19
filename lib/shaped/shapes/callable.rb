# frozen_string_literal: true

class Shaped::Shapes::Callable < Shaped::Shape
  def initialize(callable)
    @callable = callable
  end

  def matched_by?(object)
    !!@callable.call(object)
  end

  def to_s
    case @callable
    when Proc then "Proc test defined at #{@callable.source_location.map(&:to_s).join(':')}"
    else "#call test defined at #{@callable.method(:call).source_location.map(&:to_s).join(':')}"
    end
  end
end
