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
