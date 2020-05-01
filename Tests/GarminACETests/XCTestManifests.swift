import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ACEFileDecoderSpec.allTests),
        testCase(ACEFileEncoderSpec.allTests)
    ]
}
#endif
