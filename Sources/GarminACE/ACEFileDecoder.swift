import Foundation
import SwiftScanner

/**
 Decodes an `.ace` file into a ``ChecklistFile`` instance.
 */
public class ACEFileDecoder {
    
    /**
     Decodes a `Data` instance into a ``ChecklistFile``.
     
     - Parameter data: The data of the `.ace` file.
     - Returns: The parsed checklists.
     - Throws: If a parse error occurs.
     */
    public func decode(data: Data) throws -> ChecklistFile {
        let header = data[data.startIndex...data.index(data.startIndex, offsetBy: 9)]
        guard header == Constants.magicNumberAndRevision else { throw DecoderError.invalidMagicNumberOrRevision }
        let body = data.advanced(by: 10)
        guard let bodyString = String(data: body, encoding: .windowsCP1252) else { throw DecoderError.invalidEncoding }
        return try decodeBody(bodyString)
        
        //TODO decode trailing binary data (unknown format)
    }
    
    private func decodeBody(_ body: String) throws -> ChecklistFile {
        let scanner = StringScanner(body)
        
        let checklistSet = try scanHeader(scanner)
        while !scanner.match(Constants.setEnd) {
            guard let checklistGroup = try scanGroup(scanner) else {
                throw DecoderError.expectedChecklistGroup
            }
            checklistSet.groups.append(checklistGroup)
        }
        guard scanner.match(Constants.CRLF) else { throw DecoderError.expectedNewline }
        
        return checklistSet
    }
    
    private func scanHeader(_ scanner: StringScanner) throws -> ChecklistFile {
        guard let name = try? scanner.scan(upTo: Constants.CRLF) else { throw DecoderError.invalidHeader }
        try scanner.skip(length: 2)
        
        guard let makeAndModel = try? scanner.scan(upTo: Constants.CRLF) else { throw DecoderError.invalidHeader }
        try scanner.skip(length: 2)
        
         guard let aircraftInfo = try? scanner.scan(upTo: Constants.CRLF) else { throw DecoderError.invalidHeader }
        try scanner.skip(length: 2)
        
        guard let manufacturerID = try? scanner.scan(upTo: Constants.CRLF) else { throw DecoderError.invalidHeader }
        try scanner.skip(length: 2)
        
        guard let copyright = try? scanner.scan(upTo: Constants.CRLF) else { throw DecoderError.invalidHeader }
        try scanner.skip(length: 2)
        
        return ChecklistFile(name: name, makeAndModel: makeAndModel, aircraftInfo: aircraftInfo, manufacturerID: manufacturerID, copyright: copyright)

    }
    
    private func scanGroup(_ scanner: StringScanner) throws -> ChecklistGroup? {
        guard try scanner.scan(length: 1) == Constants.groupStart else { return nil }
        
        guard let indent = try? scanner.scan(length: 1).first else { throw DecoderError.invalidGroup }
        
        guard let name = try? scanner.scan(upTo: Constants.CRLF) else { throw DecoderError.invalidHeader }
        try scanner.skip(length: 2)
        
        let group = ChecklistGroup(name: name, indent: try parseIndent(indent))
        
        while !scanner.match(Constants.groupEnd) {
            guard let checklist = try scanChecklist(scanner) else {
                throw DecoderError.expectedChecklist
            }
            group.checklists.append(checklist)
        }
        guard scanner.match(Constants.CRLF) else { throw DecoderError.expectedNewline }
        
        return group
    }
    
    private func scanChecklist(_ scanner: StringScanner) throws -> Checklist? {
        guard try scanner.scan(length: 1) == Constants.checklistStart else { return nil }
        
        guard let indent = try? scanner.scan(length: 1).first else { throw DecoderError.invalidChecklist }

        guard let name = try? scanner.scan(upTo: Constants.CRLF) else { throw DecoderError.invalidHeader }
        try scanner.skip(length: 2)
        
        let checklist = Checklist(name: name, indent: try parseIndent(indent))
        
        while !scanner.match(Constants.checklistEnd) {
            let item = try scanItem(scanner)
            checklist.items.append(item)
        }
        guard scanner.match(Constants.CRLF) else { throw DecoderError.expectedNewline }

        return checklist
    }
    
    private func scanItem(_ scanner: StringScanner) throws -> Checklist.Item {
        if scanner.match(Constants.CRLF) {
            return .blank
        }
        
        guard let typeChar = try? scanner.scan(length: 1).first else { throw DecoderError.invalidItem }
        guard let indentChar = try? scanner.scan(length: 1).first else { throw DecoderError.invalidItem }
        
        guard let type = ItemType(rawValue: typeChar) else { throw DecoderError.invalidItem }
        let indent = try parseIndent(indentChar)
        
        guard let content = try? scanner.scan(upTo: Constants.CRLF) else { throw DecoderError.invalidHeader }
        try scanner.skip(length: 2)
        
        switch type {
            case .title: return .title(text: content, indent: indent)
            case .warning: return .warning(text: content, indent: indent)
            case .caution: return .caution(text: content, indent: indent)
            case .note: return .note(text: content, indent: indent)
            case .plaintext: return .plaintext(text: content, indent: indent)
            case .challengeResponse:
                let parts = (content).split(separator: Constants.challengeResponseSeparator)
                return Checklist.Item.challengeResponse(challenge: String(parts[0]), response: String(parts[1]), indent: indent)
        }
    }
    
    private func parseIndent(_ indent: Character) throws -> Indent {
        if indent == Constants.centeredIndent { return .centered }
        else if let level = UInt(String(indent)) { return .level(level) }
        else { throw DecoderError.invalidIndentLevel(indent) }
    }
    
    private enum ItemType: Character {
        case title = "t"
        case warning = "w"
        case caution = "c"
        case note = "n"
        case plaintext = "p"
        case challengeResponse = "r"
    }
}
