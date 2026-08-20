import Foundation
import Testing

@testable import GarminACE

@Suite("ACE file encoder")
struct ACEFileEncoderTests {

  static func checklistSet() throws -> ChecklistFile {
    let url = try #require(Bundle.module.url(forResource: "g3x_cklst", withExtension: "json"))
    return try JSONDecoder().decode(ChecklistFile.self, from: Data(contentsOf: url))
  }

  static func fixtureData() throws -> Data {
    let url = try #require(Bundle.module.url(forResource: "g3x_cklst", withExtension: "ace"))
    return try Data(contentsOf: url)
  }

  @Test("Exports the example checklist")
  func exportsExampleChecklist() throws {
    let data = try ACEFileEncoder(checklistSet: Self.checklistSet()).writeToData()
    let expected = try Self.fixtureData()
    #expect(data == expected)
  }
}
