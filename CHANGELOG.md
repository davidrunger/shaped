## Unreleased
### Added
- Add `Shaped::Array` method and class
- Add `Array` refinement
- Add `Shaped::MatchFailureReason` and `Shaped::Array#match_failure_reason`

### Fixed
- Fix potential memory leak in long-lived `Shaped::Array` instances

### Tests
- Move `Shaped::Array#match_failure_reason` specs to the correct file

## 0.1.0 - 2020-06-16
- Initial release of Shaped! Validate the shape of Ruby hashes and/or arrays.
