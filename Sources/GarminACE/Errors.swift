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
        String(localized: "Couldn’t decode checklist file.", comment: "error description")
    }

    public var failureReason: String? {
        switch self {
            case .invalidMagicNumberOrRevision:
                return String(localized: "Invalid magic number or revision.", comment: "failure reason")
            case .invalidEncoding:
                return String(localized: "Invalid encoding.", comment: "failure reason")
            case .invalidHeader:
                return String(localized: "Invalid header data.", comment: "failure reason")
            case .invalidGroup:
                return String(localized: "Invalid checklist group data.", comment: "failure reason")
            case .invalidChecklist:
                return String(localized: "Invalid checklist data.", comment: "failure reason")
            case .expectedChecklistGroup:
                return String(localized: "Expected checklist group data but found none.", comment: "failure reason")
            case .expectedChecklist:
                return String(localized: "Expected checklist data but found none.", comment: "failure reason")
            case .expectedNewline:
                return String(localized: "Expected newline but found none.", comment: "failure reason")
            case .invalidItem:
                return String(localized: "Invalid checklist item data.", comment: "failure reason")
            case let .invalidIndentLevel(level):
                return String(localized: "Invalid indent level ‘\(String(level))’.", comment: "failure reason")
            case .missingEnd:
                return String(localized: "Missing end data.", comment: "failure reason")
        }
    }

    public var recoverySuggestion: String? {
        String(localized: "Verify that the .ace file is properly formatted.", comment: "recovery suggestion")
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
        String(localized: "Couldn’t write checklist file.", comment: "error description")
    }

    public var failureReason: String? {
        switch self {
            case .invalidCharacterForEncoding:
                return String(localized: "String cannot be encoded as CP1252.", comment: "failure reason")
            case .invalidURL:
                return String(localized: "Output URL can’t be written to.", comment: "failure reason")
        }
    }

    public var recoverySuggestion: String? {
        switch self {
            case .invalidCharacterForEncoding:
                return String(localized: "Verify that all checklists, groups, and items contain no special characters.", comment: "recovery suggestion")
            case .invalidURL:
                return String(localized: "Verify that the URL points to a file with write permission.", comment: "recovery suggestion")
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
        String(localized: "Couldn’t decode checklist.", comment: "error description")
    }

    public var failureReason: String? {
        switch self {
            case let .unknownIndent(value):
                return String(localized: "Invalid indent value “\(value)”.", comment: "failure reason")

            case let .unknownItemType(value):
                return String(localized: "Invalid item type “\(value)”.", comment: "failure reason")
        }
    }

    public var recoverySuggestion: String? {
                    String(localized: "Verify that the checklist was encoded with the same version of GarminACE.", comment: "recovery suggestion")
    }
}
