# Change Log

## [2.0.0] - 2026-07-26

### Fixed

- `ACEFileDecoder` now has a public initializer. It was previously impossible to
  instantiate the decoder from outside the module.
- Item type `a` (caution) is now decoded. Files containing a caution previously
  failed with `DecoderError.invalidItem`.
- Item type `c` is now decoded as `Checklist.Item.challenge`, a checkable item
  with no response, rather than as a caution.
- Centered text is encoded as a lowercase `c`, matching the files the Garmin
  Aviation Checklist Editor produces.
- `ACEFileDecoder` accepts revision `0100` in addition to `0110`.
- Corrected the usage examples in the README and DocC documentation.

### Breaking

- `Checklist.Item` has a new case, `challenge(text:indent:)`. Exhaustive
  `switch` statements over `Checklist.Item` must handle it.
- Items that previously decoded as `caution` now decode as `challenge`, and
  `caution` is written as `a` rather than `c`.

## [1.0.1] - 2026-06-26

### Changed

- Adopted the Approachable Concurrency upcoming features
  (`NonisolatedNonsendingByDefault`, `InferIsolatedConformances`). The library
  is fully synchronous, so there is no change to the public API or behavior.

## [1.0.0] - 2024-04-03

Initial release.
