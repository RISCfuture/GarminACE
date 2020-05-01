//
//  File.swift
//  
//
//  Created by Tim Morgan on 5/1/20.
//

import Foundation

/**
 - Important: This class is incomplete and does not yet generate valid `.ace`
   files.
 */

public class ACEFileEncoder {
    public let checklistSet: ChecklistFile
    
    private let newline = Data([13, 10])
    
    init(checklistSet: ChecklistFile) {
        self.checklistSet = checklistSet
    }
    
    public func writeToData() throws -> Data {
        let stream = OutputStream.toMemory()
        stream.open()
        try encode(to: stream)
        stream.close()
        
        return stream.property(forKey: .dataWrittenToMemoryStreamKey) as! Data
    }
    
    public func writeToURL(URL: URL) throws {
        guard let stream = OutputStream(url: URL, append: false) else {
            throw Error.invalidURL
        }
        try encode(to: stream)
    }
    
    public func encode(to stream: OutputStream) throws {
        Constants.magicNumberAndRevision.withUnsafeBytes {
            stream.write($0, maxLength: Constants.magicNumberAndRevision.count)
        }
        
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
            throw Error.invalidCharacterForEncoding
        }
        _ = data.withUnsafeBytes { stream.write($0, maxLength: data.count) }
        if newline {
            _ = self.newline.withUnsafeBytes { stream.write($0, maxLength: self.newline.count) }
        }
    }
    
    public enum Error: Swift.Error {
        case invalidCharacterForEncoding
        case invalidURL
    }
}
