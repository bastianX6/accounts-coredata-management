//
//  CoreDataSourceReadTests.swift
//
//
//  Created by Bastián Véliz Vega on 12-09-20.
//

@testable import AccountsCoreDataManagement
import DataManagement
import XCTest

final class CoreDataSourceReadTests: XCTestCase {
    static var allTests = [
        ("testReadElement", testReadElement),
        ("testReadElements", testReadElements),
        ("testReadElementsByStore", testReadElementsByStore),
        ("testReadElementsByCategory", testReadElementsByCategory),
        ("testReadElementsByPayment", testReadElementsByPayment),
        ("testReadElementsByDateInterval", testReadElementsByDateInterval),
    ]

    var sut: CoreDataSourceRead?

    override func setUpWithError() throws {
        try super.setUpWithError()
        self.sut = CoreDataSourceRead(persistentContainer: MockPersistantContainer.shared.container)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        try MockPersistantContainer.shared.deleteAll()
    }

    func testReadElement() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        // Check if movement is saved
        let mockMovement = MockMovement()
        let result = self.addMovement(mockMovement: mockMovement)

        XCTAssertNil(result.error)

        // Check if movement can be read
        let movement = try dataSource
            .readMovement(id: mockMovement.id)
            .wait(timeout: 5)
            .single()

        self.check(mockMovement: mockMovement, movement: movement)
    }

    func testReadElements() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        // Check if movement is saved
        let mockMovement = MockMovement()
        let mockMovement2 = MockMovement()
        let result = self.addMovement(mockMovement: mockMovement)
        let result2 = self.addMovement(mockMovement: mockMovement2)

        XCTAssertNil(result.error)
        XCTAssertNil(result2.error)

        let query = ReadMovementsQuery(fromDate: Date(timeIntervalSince1970: 0),
                                       toDate: Date())

        // Check if movement can be read
        let movements = try dataSource
            .readMovements(query: query)
            .wait(timeout: 5)
            .single()

        XCTAssertEqual(movements.count, 2)
    }

    func testReadElementsByStore() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        // Check if movement is saved
        let storeId = UUID()
        var mockMovement = MockMovement()
        mockMovement.storeId = storeId
        let mockMovement2 = MockMovement()
        let result = self.addMovement(mockMovement: mockMovement)
        let result2 = self.addMovement(mockMovement: mockMovement2)

        XCTAssertNil(result.error)
        XCTAssertNil(result2.error)

        let query = ReadMovementsQuery(fromDate: Date(timeIntervalSince1970: 0),
                                       toDate: Date(),
                                       storeId: storeId)

        // Check if movement can be read
        let movements = try dataSource
            .readMovements(query: query)
            .wait(timeout: 5)
            .single()

        XCTAssertEqual(movements.count, 1)
    }

    func testReadElementsByCategory() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        // Check if movement is saved
        let categoryId = UUID()
        var mockMovement = MockMovement()
        mockMovement.categoryId = categoryId
        let mockMovement2 = MockMovement()
        let result = self.addMovement(mockMovement: mockMovement)
        let result2 = self.addMovement(mockMovement: mockMovement2)

        XCTAssertNil(result.error)
        XCTAssertNil(result2.error)

        let query = ReadMovementsQuery(fromDate: Date(timeIntervalSince1970: 0),
                                       toDate: Date(),
                                       categoryId: categoryId)

        // Check if movement can be read
        let movements = try dataSource
            .readMovements(query: query)
            .wait(timeout: 5)
            .single()

        XCTAssertEqual(movements.count, 1)
    }

    func testReadElementsByPayment() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        // Check if movement is saved
        let paymentId = UUID()
        var mockMovement = MockMovement()
        mockMovement.paymentId = paymentId
        let mockMovement2 = MockMovement()
        let result = self.addMovement(mockMovement: mockMovement)
        let result2 = self.addMovement(mockMovement: mockMovement2)

        XCTAssertNil(result.error)
        XCTAssertNil(result2.error)

        let query = ReadMovementsQuery(fromDate: Date(timeIntervalSince1970: 0),
                                       toDate: Date(),
                                       paymentId: paymentId)

        // Check if movement can be read
        let movements = try dataSource
            .readMovements(query: query)
            .wait(timeout: 5)
            .single()

        XCTAssertEqual(movements.count, 1)
    }

    func testReadElementsByDateInterval() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        guard let movementDate = dateFormat.date(from: "2018-02-01"),
            let startingDate = dateFormat.date(from: "2019-01-01") else {
            XCTFail("Can't get dates")
            return
        }

        // Check if movement is saved
        var mockMovement = MockMovement()
        mockMovement.date = movementDate
        let mockMovement2 = MockMovement()

        let result = self.addMovement(mockMovement: mockMovement)
        let result2 = self.addMovement(mockMovement: mockMovement2)

        XCTAssertNil(result.error)
        XCTAssertNil(result2.error)

        let query = ReadMovementsQuery(fromDate: startingDate,
                                       toDate: Date())

        // Check if movement can be read
        let movements = try dataSource
            .readMovements(query: query)
            .wait(timeout: 5)
            .single()

        XCTAssertEqual(movements.count, 1)
    }

    // MARK: - Sum methods

    func testGetMovementSumByCategory() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        // create and add mock movements

        let categoryId = UUID()
        let mockMovement1 = MockMovement(amount: 100, categoryId: categoryId)
        let mockMovement2 = MockMovement(amount: 200, categoryId: categoryId)
        let mockMovement3 = MockMovement(amount: 300, categoryId: categoryId)
        let mockMovement4 = MockMovement(amount: 400, categoryId: categoryId)

        let result1 = self.addMovement(mockMovement: mockMovement1)
        let result2 = self.addMovement(mockMovement: mockMovement2)
        let result3 = self.addMovement(mockMovement: mockMovement3)
        let result4 = self.addMovement(mockMovement: mockMovement4)

        XCTAssertNil(result1.error)
        XCTAssertNil(result2.error)
        XCTAssertNil(result3.error)
        XCTAssertNil(result4.error)

        // query sum
        let query = ReadMovementsQuery(fromDate: Date(timeIntervalSince1970: 0),
                                       toDate: Date())

        let sum = try dataSource
            .getMovementSumByCategory(query: query)
            .wait(timeout: 5)
            .single()

        XCTAssertEqual(sum.count, 1)

        guard let firstElement = sum.first else {
            XCTFail("Couldn't get first array value")
            return
        }

        XCTAssertEqual(firstElement.id, categoryId)
        XCTAssertEqual(firstElement.sum, mockMovement1.amount
            + mockMovement2.amount
            + mockMovement3.amount
            + mockMovement4.amount)
    }

    func testGetMovementSumByCategoryMultiple() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        // create and add mock movements

        let categoryId1 = UUID()
        let categoryId2 = UUID()
        let mockMovement1 = MockMovement(amount: 100, categoryId: categoryId1)
        let mockMovement2 = MockMovement(amount: 200, categoryId: categoryId1)
        let mockMovement3 = MockMovement(amount: 300, categoryId: categoryId2)
        let mockMovement4 = MockMovement(amount: 400, categoryId: categoryId2)

        let result1 = self.addMovement(mockMovement: mockMovement1)
        let result2 = self.addMovement(mockMovement: mockMovement2)
        let result3 = self.addMovement(mockMovement: mockMovement3)
        let result4 = self.addMovement(mockMovement: mockMovement4)

        XCTAssertNil(result1.error)
        XCTAssertNil(result2.error)
        XCTAssertNil(result3.error)
        XCTAssertNil(result4.error)

        // query sum
        let query = ReadMovementsQuery(fromDate: Date(timeIntervalSince1970: 0),
                                       toDate: Date())

        var sum = try dataSource
            .getMovementSumByCategory(query: query)
            .wait(timeout: 5)
            .single()

        sum.sort(by: { $0.sum < $1.sum })

        XCTAssertEqual(sum.count, 2)

        guard let firstElement = sum.first else {
            XCTFail("Couldn't get first array value")
            return
        }

        guard let lastElement = sum.last else {
            XCTFail("Couldn't get last array value")
            return
        }

        XCTAssertEqual(firstElement.id, categoryId1)
        XCTAssertEqual(firstElement.sum, mockMovement1.amount + mockMovement2.amount)

        XCTAssertEqual(lastElement.id, categoryId2)
        XCTAssertEqual(lastElement.sum, mockMovement3.amount + mockMovement4.amount)
    }

    func testGetMovementSumByCategoryTimeInterval() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        guard let movementDate = dateFormat.date(from: "2018-02-01"),
            let startingDate = dateFormat.date(from: "2019-01-01") else {
            XCTFail("Can't get dates")
            return
        }

        // create and add mock movements

        let categoryId1 = UUID()
        let categoryId2 = UUID()
        let mockMovement1 = MockMovement(amount: 100, date: movementDate, categoryId: categoryId1)
        let mockMovement2 = MockMovement(amount: 200, date: movementDate, categoryId: categoryId2)
        let mockMovement3 = MockMovement(amount: 300, categoryId: categoryId1)
        let mockMovement4 = MockMovement(amount: 400, categoryId: categoryId2)

        let result1 = self.addMovement(mockMovement: mockMovement1)
        let result2 = self.addMovement(mockMovement: mockMovement2)
        let result3 = self.addMovement(mockMovement: mockMovement3)
        let result4 = self.addMovement(mockMovement: mockMovement4)

        XCTAssertNil(result1.error)
        XCTAssertNil(result2.error)
        XCTAssertNil(result3.error)
        XCTAssertNil(result4.error)

        // query sum
        let query = ReadMovementsQuery(fromDate: startingDate,
                                       toDate: Date())

        var sum = try dataSource
            .getMovementSumByCategory(query: query)
            .wait(timeout: 5)
            .single()

        sum.sort(by: { $0.sum < $1.sum })

        XCTAssertEqual(sum.count, 2)

        guard let firstElement = sum.first else {
            XCTFail("Couldn't get first array value")
            return
        }

        guard let lastElement = sum.last else {
            XCTFail("Couldn't get last array value")
            return
        }

        XCTAssertEqual(firstElement.id, categoryId1)
        XCTAssertEqual(firstElement.sum, mockMovement3.amount)

        XCTAssertEqual(lastElement.id, categoryId2)
        XCTAssertEqual(lastElement.sum, mockMovement4.amount)
    }

    func testGetMovementSumByStore() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        // create and add mock movements

        let storeId = UUID()
        let mockMovement1 = MockMovement(amount: 100, storeId: storeId)
        let mockMovement2 = MockMovement(amount: 200, storeId: storeId)
        let mockMovement3 = MockMovement(amount: 300, storeId: storeId)
        let mockMovement4 = MockMovement(amount: 400, storeId: storeId)

        let result1 = self.addMovement(mockMovement: mockMovement1)
        let result2 = self.addMovement(mockMovement: mockMovement2)
        let result3 = self.addMovement(mockMovement: mockMovement3)
        let result4 = self.addMovement(mockMovement: mockMovement4)

        XCTAssertNil(result1.error)
        XCTAssertNil(result2.error)
        XCTAssertNil(result3.error)
        XCTAssertNil(result4.error)

        // query sum
        let query = ReadMovementsQuery(fromDate: Date(timeIntervalSince1970: 0),
                                       toDate: Date())

        let sum = try dataSource
            .getMovementSumByStore(query: query)
            .wait(timeout: 5)
            .single()

        XCTAssertEqual(sum.count, 1)

        guard let firstElement = sum.first else {
            XCTFail("Couldn't get first array value")
            return
        }

        XCTAssertEqual(firstElement.id, storeId)
        XCTAssertEqual(firstElement.sum, mockMovement1.amount
            + mockMovement2.amount
            + mockMovement3.amount
            + mockMovement4.amount)
    }

    func testGetMovementSumByStoreMultiple() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        // create and add mock movements

        let storeId1 = UUID()
        let storeId2 = UUID()
        let mockMovement1 = MockMovement(amount: 100, storeId: storeId1)
        let mockMovement2 = MockMovement(amount: 200, storeId: storeId1)
        let mockMovement3 = MockMovement(amount: 300, storeId: storeId2)
        let mockMovement4 = MockMovement(amount: 400, storeId: storeId2)

        let result1 = self.addMovement(mockMovement: mockMovement1)
        let result2 = self.addMovement(mockMovement: mockMovement2)
        let result3 = self.addMovement(mockMovement: mockMovement3)
        let result4 = self.addMovement(mockMovement: mockMovement4)

        XCTAssertNil(result1.error)
        XCTAssertNil(result2.error)
        XCTAssertNil(result3.error)
        XCTAssertNil(result4.error)

        // query sum
        let query = ReadMovementsQuery(fromDate: Date(timeIntervalSince1970: 0),
                                       toDate: Date())

        var sum = try dataSource
            .getMovementSumByStore(query: query)
            .wait(timeout: 5)
            .single()

        XCTAssertEqual(sum.count, 2)

        sum.sort(by: { $0.sum < $1.sum })

        guard let firstElement = sum.first else {
            XCTFail("Couldn't get first array value")
            return
        }

        guard let lastElement = sum.last else {
            XCTFail("Couldn't get last array value")
            return
        }

        XCTAssertEqual(firstElement.id, storeId1)
        XCTAssertEqual(firstElement.sum, mockMovement1.amount + mockMovement2.amount)

        XCTAssertEqual(lastElement.id, storeId2)
        XCTAssertEqual(lastElement.sum, mockMovement3.amount + mockMovement4.amount)
    }

    func testGetMovementSumByStoreTimeInterval() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        guard let movementDate = dateFormat.date(from: "2018-02-01"),
            let startingDate = dateFormat.date(from: "2019-01-01") else {
            XCTFail("Can't get dates")
            return
        }

        // create and add mock movements

        let storeId1 = UUID()
        let storeId2 = UUID()
        let mockMovement1 = MockMovement(amount: 100, date: movementDate, storeId: storeId1)
        let mockMovement2 = MockMovement(amount: 200, date: movementDate, storeId: storeId2)
        let mockMovement3 = MockMovement(amount: 300, storeId: storeId1)
        let mockMovement4 = MockMovement(amount: 400, storeId: storeId2)

        let result1 = self.addMovement(mockMovement: mockMovement1)
        let result2 = self.addMovement(mockMovement: mockMovement2)
        let result3 = self.addMovement(mockMovement: mockMovement3)
        let result4 = self.addMovement(mockMovement: mockMovement4)

        XCTAssertNil(result1.error)
        XCTAssertNil(result2.error)
        XCTAssertNil(result3.error)
        XCTAssertNil(result4.error)

        // query sum
        let query = ReadMovementsQuery(fromDate: startingDate,
                                       toDate: Date())

        var sum = try dataSource
            .getMovementSumByStore(query: query)
            .wait(timeout: 5)
            .single()

        XCTAssertEqual(sum.count, 2)

        sum.sort(by: { $0.sum < $1.sum })

        guard let firstElement = sum.first else {
            XCTFail("Couldn't get first array value")
            return
        }

        guard let lastElement = sum.last else {
            XCTFail("Couldn't get last array value")
            return
        }

        XCTAssertEqual(firstElement.id, storeId1)
        XCTAssertEqual(firstElement.sum, mockMovement3.amount)

        XCTAssertEqual(lastElement.id, storeId2)
        XCTAssertEqual(lastElement.sum, mockMovement4.amount)
    }

    // MARK: - Private functions

    private func addMovement(mockMovement: MockMovement) -> PublisherResult<Void, Error> {
        let dataSource = CoreDataSourceModify(persistentContainer: MockPersistantContainer.shared.container)
        let result = dataSource
            .save(movement: mockMovement)
            .wait(timeout: 5)

        return result
    }

    private func check(mockMovement: MockMovement, movement: Movement) {
        XCTAssertEqual(mockMovement.id, movement.id)
        XCTAssertEqual(mockMovement.name, movement.name)
        XCTAssertEqual(mockMovement.description, movement.description)
        XCTAssertEqual(mockMovement.amount, movement.amount)
        XCTAssertEqual(mockMovement.date, movement.date)
        XCTAssertEqual(mockMovement.isPaid, movement.isPaid)
        XCTAssertEqual(mockMovement.storeId, movement.storeId)
        XCTAssertEqual(mockMovement.categoryId, movement.categoryId)
        XCTAssertEqual(mockMovement.paymentId, movement.paymentId)
    }
}
