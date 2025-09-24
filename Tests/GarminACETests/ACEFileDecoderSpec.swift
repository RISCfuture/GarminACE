import Foundation
import Nimble
import Quick

@testable import GarminACE

@available(OSX 10.15, *)
final class ACEDecoderSpec: QuickSpec {
  private static var fixtureData: Data {
    get throws {
      let url = Bundle.module.url(forResource: "g3x_cklst", withExtension: "ace")!
      return try Data(contentsOf: url)
    }
  }

  override static func spec() {
    it("imports the example checklist") {
      let set = try ACEFileDecoder().decode(data: self.fixtureData)

      expect(set.name).to(equal("GARMIN CHECKLIST PN XXX-XXXXX-XX"))
      expect(set.groups.count).to(equal(9))
      expect(set.groups[0].name).to(equal("CHECKLISTS - NORMAL"))
      expect(set.groups[0].checklists.count).to(equal(7))
      expect(set.groups[0].checklists[0].name).to(equal("PRE-START"))
      expect(set.groups[0].checklists[0].items.count).to(equal(38))

      guard case .title(let text, let indent) = set.groups[0].checklists[0].items[0] else {
        fail("Expected .title, got \(set.groups[0].checklists[0].items[0])")
        return
      }
      expect(text).to(equal("BEFORE START"))
      expect(indent).to(equal(.level(0)))
    }
  }
}
