import Foundation
import Nimble
import Quick
@testable import GarminACE

@available(OSX 10.15, *)
class ACEDecoderSpec: QuickSpec {
    private let fixtureData: Data = {
        let url = Bundle.module.url(forResource: "g3x_cklst", withExtension: "ace")!
        return try! Data(contentsOf: url)
    }()
    
    override func spec() {
        it("imports the example checklist") {
            let set = try! ACEFileDecoder().decode(data: self.fixtureData)
            
            expect(set.name).to(equal("GARMIN CHECKLIST PN XXX-XXXXX-XX"))
            expect(set.groups.count).to(equal(9))
            expect(set.groups[0].name).to(equal("CHECKLISTS - NORMAL"))
            expect(set.groups[0].checklists.count).to(equal(7))
            expect(set.groups[0].checklists[0].name).to(equal("PRE-START"))
            expect(set.groups[0].checklists[0].items.count).to(equal(38))
            switch set.groups[0].checklists[0].items[0] {
                case .title(let text, let indent):
                    expect(text).to(equal("BEFORE START"))
                    switch indent {
                        case .level(let level):
                            expect(level).to(equal(0))
                        default: fail()
                    }
                default:
                    fail()
            }
        }
    }
}
