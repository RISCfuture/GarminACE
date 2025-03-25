import Foundation
@testable import GarminACE
import Nimble
import Quick

final class ACEEncoderSpec: QuickSpec {
    private static var checklistSet: ChecklistFile {
        get throws {
            let url = Bundle.module.url(forResource: "g3x_cklst", withExtension: "json")!
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(ChecklistFile.self, from: data)
        }
    }

    private static var fixtureData: Data {
        get throws {
            let url = Bundle.module.url(forResource: "g3x_cklst", withExtension: "ace")!
            return try Data(contentsOf: url)
        }
    }

    override static func spec() {
        it("exports the example checklist") {
            let data = try ACEFileEncoder(checklistSet: self.checklistSet).writeToData()
            try expect(data).to(equal(self.fixtureData))
        }
    }
}
