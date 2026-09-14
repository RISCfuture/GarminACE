# Change Log

## [Unreleased]

### Removed

- Dropped the CryptoSwift dependency. The `.ace` trailer checksum is computed
  by a local reflected CRC-32 implementation, so the package now depends only
  on SwiftScanner.

## [2.0.0] - 2026-09-14

### Changed

- Lowered the minimum platform versions to macOS 13, iOS 16, watchOS 9, and
  tvOS 16 (from macOS 14, iOS 17, watchOS 10, and tvOS 17). Nothing in the
  package required the higher versions.

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
