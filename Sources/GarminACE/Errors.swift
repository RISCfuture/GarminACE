import Foundation

/// Errors that can occur when decoding an `.ace` file.
public enum DecoderError: Error {

  /// The magic number or revision at the start of the file is invalid.
  case invalidMagicNumberOrRevision

  /// The file is not CP12520-encoded.
  case invalidEncoding

  /// The header data is invalid.
  case invalidHeader

  /// The checklist group data is invalid.
  case invalidGroup

  /// The checklist data is invalid.
  case invalidChecklist

  /// A checklist group was expected but none was found.
  case expectedChecklistGroup

  /// A checklist was expected but none was found.
  case expectedChecklist

  /// A newline was expected but none was found.
  case expectedNewline

  /// The checklist item data is invalid.
  case invalidItem

  /**
   An invalid indent level was specified.
  
   - Parameter indent: The indent level.
   */
  case invalidIndentLevel(_ indent: Character)

  /// The checksum data at the end of the file was expected but none was found.
  case missingEnd
}

extension DecoderError: LocalizedError {
  public var errorDescription: String? {
    #if canImport(Darwin)
      String(localized: "Couldn’t decode checklist file.", comment: "error description")
    #else
      "Couldn’t decode checklist file."
    #endif
  }

  public var failureReason: String? {
    switch self {
      case .invalidMagicNumberOrRevision:
        #if canImport(Darwin)
          return String(localized: "Invalid magic number or revision.", comment: "failure reason")
        #else
          return "Invalid magic number or revision."
        #endif
      case .invalidEncoding:
        #if canImport(Darwin)
          return String(localized: "Invalid encoding.", comment: "failure reason")
        #else
          return "Invalid encoding."
        #endif
      case .invalidHeader:
        #if canImport(Darwin)
          return String(localized: "Invalid header data.", comment: "failure reason")
        #else
          return "Invalid header data."
        #endif
      case .invalidGroup:
        #if canImport(Darwin)
          return String(localized: "Invalid checklist group data.", comment: "failure reason")
        #else
          return "Invalid checklist group data."
        #endif
      case .invalidChecklist:
        #if canImport(Darwin)
          return String(localized: "Invalid checklist data.", comment: "failure reason")
        #else
          return "Invalid checklist data."
        #endif
      case .expectedChecklistGroup:
        #if canImport(Darwin)
          return String(
            localized: "Expected checklist group data but found none.",
            comment: "failure reason"
          )
        #else
          return "Expected checklist group data but found none."
        #endif
      case .expectedChecklist:
        #if canImport(Darwin)
          return String(
            localized: "Expected checklist data but found none.",
            comment: "failure reason"
          )
        #else
          return "Expected checklist data but found none."
        #endif
      case .expectedNewline:
        #if canImport(Darwin)
          return String(localized: "Expected newline but found none.", comment: "failure reason")
        #else
          return "Expected newline but found none."
        #endif
      case .invalidItem:
        #if canImport(Darwin)
          return String(localized: "Invalid checklist item data.", comment: "failure reason")
        #else
          return "Invalid checklist item data."
        #endif
      case .invalidIndentLevel(let level):
        #if canImport(Darwin)
          return String(
            localized: "Invalid indent level ‘\(String(level))’.",
            comment: "failure reason"
          )
        #else
          return "Invalid indent level ‘\(String(level))’."
        #endif
      case .missingEnd:
        #if canImport(Darwin)
          return String(localized: "Missing end data.", comment: "failure reason")
        #else
          return "Missing end data."
        #endif
    }
  }

  public var recoverySuggestion: String? {
    #if canImport(Darwin)
      String(
        localized: "Verify that the .ace file is properly formatted.",
        comment: "recovery suggestion"
      )
    #else
      "Verify that the .ace file is properly formatted."
    #endif
  }
}

// MARK: -

/// Errors that can occur when writing an `.ace` file.
public enum EncoderError: Error {

  /// Cannot encode a character into CP1252.
  case invalidCharacterForEncoding

  /// Output URL cannot be written to.
  case invalidURL
}

extension EncoderError: LocalizedError {
  public var errorDescription: String? {
    #if canImport(Darwin)
      String(localized: "Couldn’t write checklist file.", comment: "error description")
    #else
      "Couldn’t write checklist file."
    #endif
  }

  public var failureReason: String? {
    switch self {
      case .invalidCharacterForEncoding:
        #if canImport(Darwin)
          return String(localized: "String cannot be encoded as CP1252.", comment: "failure reason")
        #else
          return "String cannot be encoded as CP1252."
        #endif
      case .invalidURL:
        #if canImport(Darwin)
          return String(localized: "Output URL can’t be written to.", comment: "failure reason")
        #else
          return "Output URL can’t be written to."
        #endif
    }
  }

  public var recoverySuggestion: String? {
    switch self {
      case .invalidCharacterForEncoding:
        #if canImport(Darwin)
          return String(
            localized:
              "Verify that all checklists, groups, and items contain no special characters.",
            comment: "recovery suggestion"
          )
        #else
          return "Verify that all checklists, groups, and items contain no special characters."
        #endif
      case .invalidURL:
        #if canImport(Darwin)
          return String(
            localized: "Verify that the URL points to a file with write permission.",
            comment: "recovery suggestion"
          )
        #else
          return "Verify that the URL points to a file with write permission."
        #endif
    }
  }
}

// MARK: -

/// Errors that can occur when encoding/decoding a ``ChecklistFile``.
public enum CodingError: Error {

  /**
   An unknown value for an indent level was provided.
  
   - Parameter value: The unknown value.
   */
  case unknownIndent(_ value: String)

  /**
   An unknown checklist item type was provided.
  
   - Parameter value: The unknown value.
   */
  case unknownItemType(_ value: String)
}

extension CodingError: LocalizedError {
  public var errorDescription: String? {
    #if canImport(Darwin)
      String(localized: "Couldn’t decode checklist.", comment: "error description")
    #else
      "Couldn’t decode checklist."
    #endif
  }

  public var failureReason: String? {
    switch self {
      case .unknownIndent(let value):
        #if canImport(Darwin)
          return String(localized: "Invalid indent value “\(value)”.", comment: "failure reason")
        #else
          return "Invalid indent value “\(value)”."
        #endif

      case .unknownItemType(let value):
        #if canImport(Darwin)
          return String(localized: "Invalid item type “\(value)”.", comment: "failure reason")
        #else
          return "Invalid item type “\(value)”."
        #endif
    }
  }

  public var recoverySuggestion: String? {
    #if canImport(Darwin)
      String(
        localized: "Verify that the checklist was encoded with the same version of GarminACE.",
        comment: "recovery suggestion"
      )
    #else
      "Verify that the checklist was encoded with the same version of GarminACE."
    #endif
  }
}
