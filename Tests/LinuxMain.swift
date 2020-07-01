import XCTest

import SimpleHttpClientTests

var tests = [XCTestCaseEntry]()
tests += EtvnetApiTests.allTests()
XCTMain(tests)
