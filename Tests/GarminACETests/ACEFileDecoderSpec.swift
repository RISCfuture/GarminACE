import Foundation
import Testing

@testable import GarminACE

@Suite("ACE file decoder")
struct ACEFileDecoderTests {

  static func fixtureData() throws -> Data {
    let url = try #require(Bundle.module.url(forResource: "g3x_cklst", withExtension: "ace"))
    return try Data(contentsOf: url)
  }

  @Test("Imports the example checklist")
  func importsExampleChecklist() throws {
    let set = try ACEFileDecoder().decode(data: Self.fixtureData())

    #expect(set.name == "GARMIN CHECKLIST PN XXX-XXXXX-XX")
    #expect(set.groups.count == 9)
    #expect(set.groups[0].name == "CHECKLISTS - NORMAL")
    #expect(set.groups[0].checklists.count == 7)
    #expect(set.groups[0].checklists[0].name == "PRE-START")
    #expect(set.groups[0].checklists[0].items.count == 38)

    let firstItem = set.groups[0].checklists[0].items[0]
    guard case let .title(text, indent) = firstItem else {
      Issue.record("Expected .title, got \(firstItem)")
      return
    }
    #expect(text == "BEFORE START")
    #expect(indent == .level(0))
  }
}
