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
    when Method then "Method defined at #{@callable.source_location.join(':')}"
    when Proc
      if @callable.source_location
        "Proc test defined at #{@callable.source_location.join(':')}"
      else
        'Proc test defined at unknown location'
      end
    else "#call test defined at #{@callable.method(:call).source_location.join(':')}"
    end
  end
end
