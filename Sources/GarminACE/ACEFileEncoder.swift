import Foundation

/**
 Encodes a ``ChecklistFile`` into a `.ace` file.
 
 - Important: This class is incomplete and does not yet generate valid `.ace`
   files.
 */
public class ACEFileEncoder {
    
    /// The checklist file to encode.
    public let checklistSet: ChecklistFile
    
    private let newline = Data([13, 10])
    
    /**
     Creates a new instance for encoding.
     
     - Parameter checklistSet: The checklist file to encode.
     */
    public init(checklistSet: ChecklistFile) {
        self.checklistSet = checklistSet
    }
    
    /**
     Writes the `.ace` file data to a `Data` instance.
     
     - Returns: The data containing the `.ace` data.
     */
    public func writeToData() throws -> Data {
        let stream = OutputStream.toMemory()
        stream.open()
        try encode(to: stream)
        stream.close()
        
        return stream.property(forKey: .dataWrittenToMemoryStreamKey) as! Data
    }
    
    /**
     Writes the `.ace` file.
     
     - Parameter url: The file URL to write to.
     */
    public func writeToURL(URL: URL) throws {
        guard let stream = OutputStream(url: URL, append: false) else {
            throw EncoderError.invalidURL
        }
        try encode(to: stream)
    }
    
    /**
     Writes the `.ace` file data to an output stream.
     
     - Parameter stream: The output stream to write to.
     */
    public func encode(to stream: OutputStream) throws {
        try stream.write(data: Constants.magicNumberAndRevision)
        try encode(set: checklistSet, to: stream)
        try encode(string: Constants.setEnd, to: stream, newline: true)
        
        //TODO encode trailing binary data (unknown format)
    }
    
    private func encode(set: ChecklistFile, to stream: OutputStream) throws {
        try encode(string: set.name, to: stream, newline: true)
        try encode(string: set.makeAndModel, to: stream, newline: true)
        try encode(string: set.aircraftInfo, to: stream, newline: true)
        try encode(string: set.manufacturerID, to: stream, newline: true)
        try encode(string: set.copyright, to: stream, newline: true)
        
        for group in set.groups {
            try encode(group: group, to: stream)
        }
    }
    
    private func encode(group: ChecklistGroup, to stream: OutputStream) throws {
        try encode(string: Constants.groupStart, to: stream)
        try encode(indent: group.indent, to: stream)
        try encode(string: group.name, to: stream, newline: true)
        
        for checklist in group.checklists {
            try encode(checklist: checklist, to: stream)
        }
        
        try encode(string: Constants.groupEnd, to: stream, newline: true)
    }
    
    private func encode(checklist: Checklist, to stream: OutputStream) throws {
        try encode(string: Constants.checklistStart, to: stream)
        try encode(indent: checklist.indent, to: stream)
        try encode(string: checklist.name, to: stream, newline: true)
        
        for item in checklist.items {
            try encode(item: item, to: stream)
        }
        
        try encode(string: Constants.checklistEnd, to: stream, newline: true)
    }
    
    private func encode(item: Checklist.Item, to stream: OutputStream) throws {
        switch item {
            case .title(let text, let indent):
                try encode(string: "t", to: stream)
                try encode(indent: indent, to: stream)
                try encode(string: text, to: stream, newline: true)
            case .warning(let text, let indent):
                try encode(string: "w", to: stream)
                try encode(indent: indent, to: stream)
                try encode(string: text, to: stream, newline: true)
            case .caution(let text, let indent):
                try encode(string: "c", to: stream)
                try encode(indent: indent, to: stream)
                try encode(string: text, to: stream, newline: true)
            case .note(let text, let indent):
                try encode(string: "n", to: stream)
                try encode(indent: indent, to: stream)
                try encode(string: text, to: stream, newline: true)
            case .plaintext(let text, let indent):
                try encode(string: "p", to: stream)
                try encode(indent: indent, to: stream)
                try encode(string: text, to: stream, newline: true)
            case .challengeResponse(let challenge, let response, let indent):
                try encode(string: "r", to: stream)
                try encode(indent: indent, to: stream)
                try encode(string: challenge, to: stream)
                try encode(character: Constants.challengeResponseSeparator, to: stream)
                try encode(string: response, to: stream, newline: true)
            case .blank:
                try encode(string: "", to: stream, newline: true)
        }
    }
    
    private func encode(indent: Indent, to stream: OutputStream) throws {
        switch indent {
            case .centered:
                try encode(character: Constants.centeredIndent, to: stream)
            case .level(let level):
                try encode(string: String(level), to: stream)
        }
    }
    
    private func encode(character: Character, to stream: OutputStream) throws {
        try encode(string: String(character), to: stream)
    }
    
    private func encode(string: String, to stream: OutputStream, newline: Bool = false) throws {
        guard let data = string.data(using: .windowsCP1252) else {
            throw EncoderError.invalidCharacterForEncoding
        }
        try stream.write(data: data)
        if newline { try stream.write(data: self.newline) }
    }
}
