import XCTest

import testPackageTests

var tests = [XCTestCaseEntry]()
tests += testPackageTests.allTests()
XCTMain(tests)
