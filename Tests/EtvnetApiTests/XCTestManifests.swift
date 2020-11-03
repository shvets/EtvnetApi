import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  [
    testCase(EtvnetApiTests.allTests),
  ]
}
#endif
