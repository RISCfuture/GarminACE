import CryptoSwift
import Foundation

/// Encodes a ``ChecklistFile`` into a `.ace` file.
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
    var data = Data()
    try write(to: &data)
    return data
  }

  /**
   Writes the `.ace` file.
  
   - Parameter url: The file URL to write to.
   */
  public func write(to url: URL) throws {
    var data = Data()
    try write(to: &data)
    try data.write(to: url)
  }

  /**
   Writes the `.ace` file data to a `Data` object.
  
   - Parameter data: The `Data` to write to.
   */
  public func write(to data: inout Data) throws {
    data.append(Constants.magicNumberAndRevision)
    try encode(set: checklistSet, to: &data)
    try encode(string: Constants.setEnd, to: &data, newline: true)

    data.append(checksum(for: data))
  }

  private func encode(set: ChecklistFile, to data: inout Data) throws {
    try encode(string: set.name, to: &data, newline: true)
    try encode(string: set.makeAndModel, to: &data, newline: true)
    try encode(string: set.aircraftInfo, to: &data, newline: true)
    try encode(string: set.manufacturerID, to: &data, newline: true)
    try encode(string: set.copyright, to: &data, newline: true)

    for group in set.groups {
      try encode(group: group, to: &data)
    }
  }

  private func encode(group: ChecklistGroup, to data: inout Data) throws {
    try encode(string: Constants.groupStart, to: &data)
    try encode(indent: group.indent, to: &data)
    try encode(string: group.name, to: &data, newline: true)

    for checklist in group.checklists {
      try encode(checklist: checklist, to: &data)
    }

    try encode(string: Constants.groupEnd, to: &data, newline: true)
  }

  private func encode(checklist: Checklist, to data: inout Data) throws {
    try encode(string: Constants.checklistStart, to: &data)
    try encode(indent: checklist.indent, to: &data)
    try encode(string: checklist.name, to: &data, newline: true)

    for item in checklist.items {
      try encode(item: item, to: &data)
    }

    try encode(string: Constants.checklistEnd, to: &data, newline: true)
  }

  private func encode(item: Checklist.Item, to data: inout Data) throws {
    switch item {
      case .title(let text, let indent):
        try encode(string: "t", to: &data)
        try encode(indent: indent, to: &data)
        try encode(string: text, to: &data, newline: true)
      case .warning(let text, let indent):
        try encode(string: "w", to: &data)
        try encode(indent: indent, to: &data)
        try encode(string: text, to: &data, newline: true)
      case .caution(let text, let indent):
        try encode(string: "c", to: &data)
        try encode(indent: indent, to: &data)
        try encode(string: text, to: &data, newline: true)
      case .note(let text, let indent):
        try encode(string: "n", to: &data)
        try encode(indent: indent, to: &data)
        try encode(string: text, to: &data, newline: true)
      case .plaintext(let text, let indent):
        try encode(string: "p", to: &data)
        try encode(indent: indent, to: &data)
        try encode(string: text, to: &data, newline: true)
      case .challengeResponse(let challenge, let response, let indent):
        try encode(string: "r", to: &data)
        try encode(indent: indent, to: &data)
        try encode(string: challenge, to: &data)
        try encode(character: Constants.challengeResponseSeparator, to: &data)
        try encode(string: response, to: &data, newline: true)
      case .blank:
        try encode(string: "", to: &data, newline: true)
    }
  }

  private func encode(indent: Indent, to data: inout Data) throws {
    switch indent {
      case .centered:
        try encode(character: Constants.centeredIndent, to: &data)
      case .level(let level):
        try encode(string: String(level), to: &data)
    }
  }

  private func encode(character: Character, to data: inout Data) throws {
    try encode(string: String(character), to: &data)
  }

  private func encode(string: String, to data: inout Data, newline: Bool = false) throws {
    guard let stringData = string.data(using: .windowsCP1252) else {
      throw EncoderError.invalidCharacterForEncoding
    }
    data.append(stringData)
    if newline { data.append(self.newline) }
  }

  private func checksum(for data: Data) -> Data {
    // In CryptoSwift 1.9, crc32() returns Data directly
    let crcData = data.crc32()
    // Convert Data to bytes array, reverse, and apply bitwise NOT
    let bytes = [UInt8](crcData)
    let reversedBytes = bytes.reversed().map { ~$0 & 0xFF }
    return Data(reversedBytes)
  }
}
