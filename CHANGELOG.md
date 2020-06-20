## Unreleased (v0.6.1.alpha)
### Docs
- Add Travis build status badge to README.md

## v0.6.0 (2020-06-19)
### Fixed
- Fix bug that would occur in the `Shaped::Shape(...)` constructor when provided with a falsy first
  argument.

## v0.5.8 (2020-06-19)
### Docs
- Document ActiveModel-style validations (which are available for `Shaped::Shapes::Class`)

## v0.5.7 (2020-06-19)
### Docs
- Wrap lines in README.md to a max of 100 characters

## v0.5.6 (2020-06-19)
### Docs
- Add a table of contents to README.md

## v0.5.5 (2020-06-19)
### Docs
- Add `require 'shaped'` to first example in README.md

## v0.5.4 (2020-06-19)
### Specs
- Fix typo in test (`@number.event?` => `@number.even?`)

## v0.5.3 (2020-06-19)
### Docs
- Fill out the "Usage" section of README.md

## v0.5.2 (2020-06-19)
### Docs
- Don't say in installation instructions to list gem in test section of Gemfile.

## v0.5.1 (2020-06-19)
### Docs
- Update description(s) to reflect broadened scope of the gem

## v0.5.0 (2020-06-19)
### Added
- Add a `Shaped::Shapes::Callable` shape, which is a shape that is defined by any object that
  responds to `#call` (e.g. a proc or an instance of a class that defines a `#call` instance
  method). This allows for essentially total flexibility in defining/describing the "shape" of an
  object.

## v0.4.0 (2020-06-18)
### Added
- Add the ability to specify ActiveModel-style validations for `Shaped::Shape::Class`es

## v0.3.2 (2020-06-18)
### Tests
- Add tests for invalid `Array` and `Or` shape definitions

## v0.3.1 (2020-06-18)
### Maintenance
- Added test coverage tracking via `simplecov` and `codecov`

## 0.3.0 - 2020-06-18
### Breaking changes
- Major refactor! See details below.

### Removed
- Remove detailed descriptions of errors ("match failure reasons")
- Remove `Array` and `Hash` refinements (`#has_shape?`)
- Removed `Shaped::Array(...)` and `Shaped::Hash(...)` constructor methods. Now, all shapes are
  created via a single, unified `Shaped::Shape(...)` method that determines which type of shape to
  build based on the class of the argument.
- Removed `Shaped.lax_mode` and `Shaped.strict_mode` settings. What was previously called `lax_mode`
  is now the default, meaning that an empty array will always be considered to match any
  `Shaped::Shapes::Array`.

### Added
- Added new shape/matcher types (plus preexisting but relocated `Shaped::Shapes::Array` and
  `Shaped::Shapes::Hash`):
  1. `Shaped::Shapes::Class`
  2. `Shaped::Shapes::Equality`
  3. `Shaped::Shapes::Or`
- All hashes and arrays in shape definitions are parsed "recursively" as shape definitions. For
  example, instead of:

```rb
Shaped::Array([
  Shaped::Hash(
    name: String,
    emails: Shaped::Hash(
      personal: Shaped::Array([String]),
      work: Shaped::Array([String]),
    ),
    favorite_numbers: Shaped::Array([Numeric]),
  ),
])
```

...one can now simply do:

```rb
Shaped::Array([
  {
    name: String,
    emails: {
      personal: [String],
      work: [String],
    },
    favorite_numbers: [Numeric],
  }
])
```

### Dependencies
- Added `activesupport` as a dependency

## 0.2.1 - 2020-06-16
### Changed
- Rename `Shaped::Array#descriptor` and `Shaped::Hash#descriptor` methods to `#to_s`

## 0.2.0 - 2020-06-16
### Added
- Add `Shaped::Array` method and class
- Add `Array` refinement
- Add `Shaped::MatchFailureReason` and `Shaped::Array#match_failure_reason`
- Add `Shaped::Hash` method and class
- Add `Hash` refinement
- Allow composing Hash and Array shape matchers together

### Fixed
- Fix potential memory leak in long-lived `Shaped::Array` instances

### Tests
- Move `Shaped::Array#match_failure_reason` specs to the correct file

## 0.1.0 - 2020-06-16
- Initial release of Shaped! Validate the shape of Ruby hashes and/or arrays.
