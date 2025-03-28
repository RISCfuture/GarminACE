import Foundation

extension Indent: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
            case "level":
                let level = try container.decode(UInt.self, forKey: .level)
                self = .level(level)
            case "centered": self = .centered
            default: throw CodingError.unknownIndent(type)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
            case .level(let level):
                try container.encode("level", forKey: .type)
                try container.encode(level, forKey: .level)
            case .centered:
                try container.encode("centered", forKey: .type)
        }
    }

    private enum Key: CodingKey {
        case type
        case level
    }
}

extension Checklist.Item: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
            case "title":
                let text = try container.decode(String.self, forKey: .text)
                let indent = try container.decode(Indent.self, forKey: .indent)
                self = .title(text: text, indent: indent)
            case "warning":
                let text = try container.decode(String.self, forKey: .text)
                let indent = try container.decode(Indent.self, forKey: .indent)
                self = .warning(text: text, indent: indent)
            case "caution":
                let text = try container.decode(String.self, forKey: .text)
                let indent = try container.decode(Indent.self, forKey: .indent)
                self = .caution(text: text, indent: indent)
            case "note":
                let text = try container.decode(String.self, forKey: .text)
                let indent = try container.decode(Indent.self, forKey: .indent)
                self = .note(text: text, indent: indent)
            case "plaintext":
                let text = try container.decode(String.self, forKey: .text)
                let indent = try container.decode(Indent.self, forKey: .indent)
                self = .plaintext(text: text, indent: indent)
            case "challengeResponse":
                let challenge = try container.decode(String.self, forKey: .challenge)
                let response = try container.decode(String.self, forKey: .response)
                let indent = try container.decode(Indent.self, forKey: .indent)
                self = .challengeResponse(challenge: challenge, response: response, indent: indent)
            case "blank":
                self = .blank
            default: throw CodingError.unknownItemType(type)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
            case let .title(text, indent):
                try container.encode("title", forKey: .type)
                try container.encode(text, forKey: .text)
                try container.encode(indent, forKey: .indent)
            case let .warning(text, indent):
                try container.encode("warning", forKey: .type)
                try container.encode(text, forKey: .text)
                try container.encode(indent, forKey: .indent)
            case let .caution(text, indent):
                try container.encode("caution", forKey: .type)
                try container.encode(text, forKey: .text)
                try container.encode(indent, forKey: .indent)
            case let .note(text, indent):
                try container.encode("note", forKey: .type)
                try container.encode(text, forKey: .text)
                try container.encode(indent, forKey: .indent)
            case let .plaintext(text, indent):
                try container.encode("plaintext", forKey: .type)
                try container.encode(text, forKey: .text)
                try container.encode(indent, forKey: .indent)
            case let .challengeResponse(challenge, response, indent):
                try container.encode("challengeResponse", forKey: .type)
                try container.encode(challenge, forKey: .challenge)
                try container.encode(response, forKey: .response)
                try container.encode(indent, forKey: .indent)
            case .blank:
                try container.encode("blank", forKey: .type)
        }
    }

    private enum Key: CodingKey {
        case type
        case text
        case challenge
        case response
        case indent
    }
}
