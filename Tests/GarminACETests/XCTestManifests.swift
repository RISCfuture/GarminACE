import XCTest

#if !canImport(ObjectiveC)
  // swiftlint:disable:next missing_docs
  public func allTests() -> [XCTestCaseEntry] {
    return [
      testCase(ACEFileDecoderSpec.allTests),
      testCase(ACEFileEncoderSpec.allTests)
    ]
  }
#endif
