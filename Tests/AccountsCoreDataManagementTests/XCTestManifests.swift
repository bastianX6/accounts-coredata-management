import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(CoreDataSourceModifyTests.allTests),
            testCase(CoreDataSourceReadTests.allTests),
        ]
    }
#endif
