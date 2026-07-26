import Foundation

enum Constants {
  static let groupStart = "<"
  static let groupEnd = ">"
  static let checklistStart = "("
  static let checklistEnd = ")"
  static let challengeResponseSeparator = Character("~")
  static let centeredIndent = Character("c")
  static let setEnd = "END"
  static let CRLF = "\r\n"

  static let magicNumber = Data([0xF0, 0xF0, 0xF0, 0xF0])

  /// The revision written by ``ACEFileEncoder``.
  static let currentRevision = Data([0, 1, 1, 0])

  /// Revisions of the `.ace` format ``ACEFileDecoder`` accepts.
  static let knownRevisions = [Data([0, 1, 0, 0]), currentRevision]

  static let headerTerminator = Data([13, 10])

  static let magicNumberAndRevision = magicNumber + currentRevision + headerTerminator

  static let headerLength = magicNumberAndRevision.count
}
