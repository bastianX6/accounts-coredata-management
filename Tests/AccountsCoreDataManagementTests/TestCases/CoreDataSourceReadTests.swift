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
