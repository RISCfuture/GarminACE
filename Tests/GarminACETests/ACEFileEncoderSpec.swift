import Foundation
import Nimble
import Quick
@testable import GarminACE

class ACEEncoderSpec: QuickSpec {
    private let checklistSet: ChecklistFile = {
        let thisFileURL = URL(fileURLWithPath: #file)
        let fixtureFileURL = thisFileURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Fixtures/g3x_cklst.json")
        let data = try! Data(contentsOf: fixtureFileURL)
        return try! JSONDecoder().decode(ChecklistFile.self, from: data)
    }()
    
    private let fixtureData: Data = {
        let thisFileURL = URL(fileURLWithPath: #file)
        let fixtureFileURL = thisFileURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Fixtures/g3x_cklst.ace")
        return try! Data(contentsOf: fixtureFileURL)
    }()
    
    override func spec() {
        it("exports the example checklist") {
            let data = try! ACEFileEncoder(checklistSet: self.checklistSet).writeToData()
            expect(data).to(equal(self.fixtureData))
        }
    }
}
