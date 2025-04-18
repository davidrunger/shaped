[![codecov](https://codecov.io/gh/davidrunger/shaped/branch/main/graph/badge.svg)](https://codecov.io/gh/davidrunger/shaped)
[![Gem Version](https://badge.fury.io/rb/shaped.svg)](https://badge.fury.io/rb/shaped)

# Shaped

Validate the "shape" of Ruby objects!

## Table of Contents

<!--ts-->
* [Shaped](#shaped)
   * [Table of Contents](#table-of-contents)
   * [Context](#context)
   * [Installation](#installation)
   * [Usage](#usage)
      * [Shape types](#shape-types)
      * [Shaped::Shapes::Hash](#shapedshapeshash)
      * [Shaped::Shapes::Array](#shapedshapesarray)
      * [Shaped::Shapes::Class](#shapedshapesclass)
         * [ActiveModel validations](#activemodel-validations)
      * [Shaped::Shapes::Method](#shapedshapesmethod)
      * [Shaped::Shapes::Callable](#shapedshapescallable)
      * [Shaped::Shapes::Equality](#shapedshapesequality)
      * [Shaped::Shapes::Any](#shapedshapesany)
      * [Shaped::Shapes::All](#shapedshapesall)
      * [#to_s](#to_s)
   * [Development](#development)
   * [For maintainers](#for-maintainers)
   * [License](#license)

<!-- Created by https://github.com/ekalinin/github-markdown-toc -->
<!-- Added by: david, at: Sat Mar 22 04:43:01 AM CDT 2025 -->

<!--te-->

## Context

The primary purpose of this gem, for now, is to serve as a dependency for the
[`active_actions`](https://github.com/davidrunger/active_actions/) gem.

The gem probably has other potential uses, too (for example, a `have_shape` RSpec matcher might be
useful), but for now supporting `active_actions` is `shaped`'s *raison d'être*.

## Installation

Add the gem to your application's `Gemfile`:

```rb
gem 'shaped'
```

And then execute:

```
$ bundle install
```

If you want to install the gem on your system independent of a project with a `Gemfile`, then you
can execute

```
$ gem install shaped
```

## Usage

The core concept of `shaped` is a "shape", by which we mean "an object that describes some
characteristic(s) that we want to be able to test other objects against".

Here's an example:
```rb
require 'shaped'

shape = Shaped::Shapes::Hash.new({ email: String, age: Integer })

shape.matched_by?({ email: 'dhh@hey.com', age: 44 }) # matches the expected hash "shape"
# => true
shape.matched_by?({ name: 'David', age: 44 }) # has a `name` key instead of `email`
# => false
shape.matched_by?({ email: 'dhh@hey.com', age: 44.4 }) # `age` is a Float, not Integer
# => false
```

### Shape types

That example references the `Shaped::Shapes::Hash` class, which is one of  `shaped`'s eight shape types (all of which inherit from `Shaped::Shape`):

1. `Shaped::Shapes::Hash`
1. `Shaped::Shapes::Array`
1. `Shaped::Shapes::Class`
1. `Shaped::Shapes::Method`
1. `Shaped::Shapes::Callable`
1. `Shaped::Shapes::Equality`
1. `Shaped::Shapes::Any`
1. `Shaped::Shapes::All`

Examples illustrating the use of each shape type are below.

### `Shaped::Shape(...)` constructor method

In the example above, we built an instance of `Shaped::Shapes::Hash` by calling
`Shaped::Shapes::Hash.new(...)`, but usually an easier/better way to build a shape object is using
the `Shaped::Shape` constructor method.

```rb
# functionally equivalent to `Shaped::Shapes::Hash.new({ email: String, age: Integer })`
shape = Shaped::Shape(email: String, age: Integer)
shape.class
# => Shaped::Shapes::Hash
shape.matched_by?(email: 'hello@example.com', age: 22)
# => true
```

The `Shaped::Shape` constructor method will automatically build the appropriate type of shape object
(one of the six types listed above), depending on the arguments provided. In this example, because
the argument to `Shaped::Shape` was a `Hash`, the `Shaped::Shape` constructor method built and
returned an instance of `Shaped::Shapes::Hash`.

### Shaped::Shapes::Hash

```rb
shape = Shaped::Shape(emails: { work: String, personal: String })

shape.matched_by?(emails: { work: 'david@google.com', personal: 'david@gmail.com' })
# => true

# the `:work` key is missing in the sub-hash
shape.matched_by?(emails: { personal: 'david@gmail.com' })
# => false

# the `'emails'` key is a String; the shape specifies that it should be a symbol
shape.matched_by?('emails' => { work: 'david@google.com', personal: 'david@gmail.com' })
# => false
```

### Shaped::Shapes::Array
```rb
shape = Shaped::Shape([String])

shape.matched_by?(['hi', 'there!']) # all elements are of the specified class
# => true
shape.matched_by?(['eight', 4, 11, 'six']) # some elements are of the wrong class
# => false
shape.matched_by?([]) # note that an empty array is considered to match
# => true
```

Note that you can specify more than one allowed class for the elements in the array:
```rb
shape = Shaped::Shape([Integer, Float])

shape.matched_by?([3.6, 10, 27, 81.99]) # all elements are either an Integer or Float
# => true
```

### Shaped::Shapes::Class

This shape is straightforward; it tests that the provided object is an instance of the specified
class (checked via `is_a?(...)`).

```rb
shape = Shaped::Shape(Numeric)

shape.matched_by?(99) # 99.is_a?(Numeric) is true
# => true

shape.matched_by?(Integer) # `Integer` is not an _instance_ of `Numeric`
# => false

shape.matched_by?('five') # 'five' is not a Numeric
# => false
```

#### ActiveModel validations

`shaped` depends on the [`activemodel` gem](https://rubygems.org/gems/activemodel) (provided by the
Ruby on Rails web framework) and leverages ActiveModel to allow for the specification of additional
validations when using the `Shaped::Shapes::Class` shape.

ActiveModel makes many different validations available! They are listed in the [Active Record
Validations](https://guides.rubyonrails.org/active_record_validations.html) Rails guide. Just a few
examples are shown below.

(These additional ActiveModel-style validations are optional; as seen in the examples above, you can
also merely check that an object is an instance of a class, without any other additional
validations.)

```rb
shape = Shaped::Shape(Numeric, numericality: { greater_than: 0 })

shape.matched_by?(77)
# => true
shape.matched_by?(-273.15)
# => false
```

```rb
shape = Shaped::Shape(String, format: { with: /.+@.+/ }, length: { minimum: 6 })

shape.matched_by?('james@protonmail.com')
# => true
shape.matched_by?('@tenderlove') # doesn't have a character preceding the "@"
# => false
shape.matched_by?('a@b.c') # too short
# => false
```

### Shaped::Shapes::Method

This shape allows specifying a method name that, when called upon a test object, must return a
truthy value in order for `matched_by?` to be true.

```rb
shape = Shaped::Shape(:odd?)

shape.matched_by?(55)
# => true

shape.matched_by?(60)
# => false
```

### Shaped::Shapes::Callable

This shape is very powerful if you need a very customized shape definition; you can define any
number of conditions/checks and they can be defined however you like. The only condition is that the
"shape definition" provided to the `Shaped::Shape(...)` constructor method must have a `#call`
instance method. For example, all Ruby procs/lambdas  have a `#call` instance method.

```rb
shape = Shaped::Shape(->(num) { (2..6).cover?(num) && num.even? })

shape.matched_by?(4) # the lamdba returns a truthy value when called with `4`
# => true

shape.matched_by?(5) # fails the `#even?` check
# => false

shape.matched_by?(10) # fails the `#cover?` check (10 is too high)
# => false
```

If you'd like to provide a named method rather than an anonymous proc/lambda, you can do that, too:

```rb
def number_is_greater_than_thirty?(number)
  number > 30
end

shape = Shaped::Shape(method(:number_is_greater_than_thirty?))

shape.matched_by?(31)
# => true

shape.matched_by?(29)
# => false
```

You can also provide an instance of a custom class that implements a `#call` instance method:

```rb
class EvenParityTester
  def call(number)
    @number = number
    number_is_even?
  end

  private

  def number_is_even?
    @number.even?
  end
end

shape = Shaped::Shape(EvenParityTester.new)

shape.matched_by?(2) # two is even
# => true

shape.matched_by?(7) # seven is not even
# => false
```

### Shaped::Shapes::Equality

`Shaped::Shapes::Equality` is the simplest shape of all; it just checks that an object is equal to
the provided "shape definition" (checked via `==`). This "shape" probably isn't very useful, in
practice.

```rb
shape = Shaped::Shape('this is the string')

shape.matched_by?('this is the string')
# => true

shape.matched_by?('this is NOT the string')
# => false
```

The `Equality` shape might be useful when it gets used behind the scenes to build another type of
shape, like a hash:

```rb
shape = Shaped::Shape(verification_code: 'abc123', new_role: String)
shape.class
# => Shaped::Shapes::Hash
shape.to_s
# => { :verification_code => "abc123", :new_role => String }

shape.matched_by?(verification_code: 'abc123', new_role: 'SuperAdmin')
# => true

# the `:verification_code` does not equal 'abc123', so the shape doesn't match
shape.matched_by?(verification_code: '321cba', new_role: 'SuperAdmin')
# => false
```

### Shaped::Shapes::Any

This shape is used behind the scenes to build "compound matchers", such as an Array shape that
allows multiple different classes:

```rb
shape = Shaped::Shape([Rational, Integer])
shape.to_s
# => [Rational OR Integer]

shape.matched_by?([Rational(1, 3), 55])
# => true

shape.matched_by?([0.333, 55])
# => false
```

You can build an `Any` shape by invoking the `Shaped::Shape` constructor with more than one argument.
Below is a (rather artificial) example illustrating this. To match this `shape`, an object must be
either greater than zero OR an Integer (or both).

```rb
shape = Shaped::Shape(->(num) { num > 0 }, Integer)

shape.matched_by?(-10) # it's an Integer
# => true

shape.matched_by?(11.5) # it's greater than 0
# => true

shape.matched_by?(-11.5) # it's neither greater than 0 nor an Integer
# => false
```

### Shaped::Shapes::All

This shape can be used to combine multiple checks, all of which must be true for a test object in
order for `#matched_by?` to be true:

```rb
shape = Shaped::Shapes::All.new(Numeric, ->(number) { number.even? })
shape.to_s
# => "Numeric AND Proc test defined at (eval):10"

shape.matched_by?(22) # 22 is both a Numeric and `#even?`
# => true

shape.matched_by?(33) # 33 is a Numeric but it's not `#even?`
# => false
```

### `#to_s`

Each Shape type implements a `#to_s` instance method that aims to provide a relatively clear
description of what the shape is checking for.

```rb
Shaped::Shape(number_of_widgets: Integer).to_s
# => { :number_of_widgets => Integer }

Shaped::Shape([Hash, OpenStruct]).to_s
# => [Hash OR OpenStruct]

Shaped::Shape(File).to_s
# => File

Shaped::Shape(->(string) { string.include?('@') }).to_s
# => Proc test defined at shaped_test.rb:5

Shaped::Shape('this will be an equality check').to_s
# => "this will be an equality check"

Shaped::Shape('allowed string one', 'allowed string two').to_s
# => "allowed string one" OR "allowed string two"
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bin/rspec` to
run the tests. You can also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine from a development copy of the code, run `bundle exec
rake install`.

## For maintainers

To release a new version, run `bin/release` with an appropriate `--type` option, e.g.:

```
bin/release --type minor
```

(This uses the [`release_assistant` gem][release_assistant].)

[release_assistant]: https://github.com/davidrunger/release_assistant/

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
