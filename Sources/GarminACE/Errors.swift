import Foundation

public enum DecoderError: Error {
    case invalidMagicNumberOrRevision
    case invalidEncoding
    case invalidHeader
    case invalidGroup
    case invalidChecklist
    case expectedChecklistGroup
    case expectedChecklist
    case expectedNewline
    case invalidItem
    case invalidIndentLevel(_ indent: Character)
    case missingEnd
}

extension DecoderError: LocalizedError {
    public var errorDescription: String? {
        t("Couldn’t decode checklist file.", comment: "error description")
    }
    
    public var failureReason: String? {
        switch self {
            case .invalidMagicNumberOrRevision:
                return t("Invalid magic number or revision.", comment: "failure reason")
            case .invalidEncoding:
                return t("Invalid encoding.", comment: "failure reason")
            case .invalidHeader:
                return t("Invalid header data.", comment: "failure reason")
            case .invalidGroup:
                return t("Invalid checklist group data.", comment: "failure reason")
            case .invalidChecklist:
                return t("Invalid checklist data.", comment: "failure reason")
            case .expectedChecklistGroup:
                return t("Expected checklist group data but found none.", comment: "failure reason")
            case .expectedChecklist:
                return t("Expected checklist data but found none.", comment: "failure reason")
            case .expectedNewline:
                return t("Expected newline but found none.", comment: "failure reason")
            case .invalidItem:
                return t("Invalid checklist item data.", comment: "failure reason")
            case let .invalidIndentLevel(level):
                return t("Invalid indent level ‘%@’.", comment: "failure reason",
                         String(level))
            case .missingEnd:
                return t("Missing end data.", comment: "failure reason")
        }
    }
    
    public var recoverySuggestion: String? {
        t("Verify that the .ace file is properly formatted.", comment: "recovery suggestion")
    }
}

// MARK: -

public enum EncoderError: Error {
    case invalidCharacterForEncoding
    case invalidURL
}

extension EncoderError: LocalizedError {
    public var errorDescription: String? {
        t("Couldn’t write checklist file.", comment: "error description")
    }
    
    public var failureReason: String? {
        switch self {
            case .invalidCharacterForEncoding:
                return t("String cannot be encoded as CP1252.", comment: "failure reason")
            case .invalidURL:
                return t("Output URL can’t be written to.", comment: "failure reason")
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
            case .invalidCharacterForEncoding:
                return t("Verify that all checklists, groups, and items contain no special characters.", comment: "recovery suggestion")
            case .invalidURL:
                return t("Verify that the URL points to a file with write permission.", comment: "recovery suggestion")
        }
    }
}

// MARK: -

public enum CodingError: Error {
    case unknownValue(_ value: String)
}

extension CodingError: LocalizedError {
    public var errorDescription: String? {
        t("Couldn’t decode checklist.", comment: "error description")
    }
    
    public var failureReason: String? {
        switch self {
            case let .unknownValue(value):
                return t("Invalid constant value “%@”.", comment: "failure reason",
                         value)
        }
    }
    
    public var recoverySuggestion: String? {
        t("Verify that the checklist was encoded with the same version of GarminACE.", comment: "recovery suggestion")
    }
}


// MARK: -

fileprivate func t(_ key: String, comment: String, _ arguments: CVarArg...) -> String {
    let template = NSLocalizedString(key, bundle: Bundle.module, comment: comment)
    return String(format: template, arguments: arguments)
}

