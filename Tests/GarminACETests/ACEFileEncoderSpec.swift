import Foundation
import Nimble
import Quick
@testable import GarminACE

class ACEEncoderSpec: QuickSpec {
    private let checklistSet: ChecklistFile = {
        let url = Bundle.module.url(forResource: "g3x_cklst", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode(ChecklistFile.self, from: data)
    }()
    
    private let fixtureData: Data = {
        let url = Bundle.module.url(forResource: "g3x_cklst", withExtension: "ace")!
        return try! Data(contentsOf: url)
    }()
    
    override func spec() {
        it("exports the example checklist") {
            let data = try! ACEFileEncoder(checklistSet: self.checklistSet).writeToData()
            expect(data).to(equal(self.fixtureData))
        }
    }
}
