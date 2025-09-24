import Foundation

enum Constants {
  static let groupStart = "<"
  static let groupEnd = ">"
  static let checklistStart = "("
  static let checklistEnd = ")"
  static let challengeResponseSeparator = Character("~")
  static let centeredIndent = Character("C")
  static let setEnd = "END"
  static let CRLF = "\r\n"

  static let magicNumberAndRevision = Data([0xF0, 0xF0, 0xF0, 0xF0, 0, 1, 1, 0, 13, 10])
  // magic number: 0xF0 * 4
  // revision: 0110
  // and a CRLF
}
