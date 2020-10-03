@testable import AccountsCoreDataManagement
import CoreData
import XCTest

final class CoreDataSourceModifyTests: XCTestCase {
    static var allTests = [
        ("testAddElement", testAddElement),
        ("testDeleteElement", testDeleteElement),
        ("testDeleteElementError", testDeleteElementError),
        ("testUpdateElement", testUpdateElement),
    ]

    var sut: CoreDataSourceModify?

    override func setUpWithError() throws {
        try super.setUpWithError()
        self.sut = CoreDataSourceModify(persistentContainer: MockPersistantContainer.shared.container)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        try MockPersistantContainer.shared.deleteAll()
    }

    func testAddElement() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        // Check if movement is saved
        let mockMovement = MockMovement()
        let result = self.addMovement(dataSource: dataSource, mockMovement: mockMovement)

        XCTAssertNil(result.error)

        // Check if movement can be read
        let movement = try self.readMovement(id: mockMovement.id)

        self.check(mockMovement: mockMovement, movement: movement)
    }

    func testDeleteElement() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        // Check if movement is saved
        let mockMovement = MockMovement()
        let result = self.addMovement(dataSource: dataSource, mockMovement: mockMovement)

        XCTAssertNil(result.error)

        // Delete movement
        let deleteResult = dataSource
            .delete(movement: mockMovement)
            .wait(timeout: 5)

        XCTAssertNil(deleteResult.error)
    }

    func testDeleteElementError() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        // Delete movement
        let mockMovement = MockMovement()
        let deleteResult = dataSource
            .delete(movement: mockMovement)
            .wait(timeout: 5)

        XCTAssertNotNil(deleteResult.error)

        guard let error = deleteResult.error as? CoreDataSourceError else {
            XCTFail("Delete fail with error: \(String(describing: deleteResult.error))")
            return
        }

        XCTAssert(error == CoreDataSourceError.noResults)
    }

    func testUpdateElement() throws {
        guard let dataSource = self.sut else {
            XCTFail("Data source is not initialized")
            return
        }

        // Check if movement is saved
        let mockMovement = MockMovement()
        let result = self.addMovement(dataSource: dataSource, mockMovement: mockMovement)

        XCTAssertNil(result.error)

        // Check if movement can be read
        var otherMockMovement = MockMovement()
        otherMockMovement.id = mockMovement.id
        otherMockMovement.name = "name"
        otherMockMovement.description = "description"
        otherMockMovement.amount = 666
        otherMockMovement.isPaid = true
        otherMockMovement.isPermanent = true

        let updateResult = dataSource
            .update(movement: otherMockMovement)
            .wait()

        XCTAssertNil(updateResult.error)

        let movement = try self.readMovement(id: otherMockMovement.id)

        self.check(mockMovement: otherMockMovement, movement: movement)
    }

    // MARK: - Private functions

    private func addMovement(dataSource: CoreDataSourceModify,
                             mockMovement: MockMovement) -> PublisherResult<Void, Error> {
        let result = dataSource
            .save(movement: mockMovement)
            .wait(timeout: 5)

        return result
    }

    private func readMovement(id: UUID) throws -> AccountMovement {
        let entityName = MockPersistantContainer.shared.accountPaymentEntity
        let context = MockPersistantContainer.shared.container.viewContext
        let fetchRequest = NSFetchRequest<AccountMovement>(entityName: entityName)
        fetchRequest.setupWith(id: id)

        let movement = try context
            .fetchPublisher(fetchRequest)
            .tryMap { movements -> AccountMovement in
                guard let accountMovement = movements.first else {
                    throw CoreDataSourceError.noResults
                }
                return accountMovement
            }
            .eraseToAnyPublisher()
            .wait(timeout: 5)
            .single()

        return movement
    }

    private func check(mockMovement: MockMovement, movement: AccountMovement) {
        XCTAssertEqual(mockMovement.id, movement.id)
        XCTAssertEqual(mockMovement.name, movement.name)
        XCTAssertEqual(mockMovement.description, movement.movementDescription)
        XCTAssertEqual(mockMovement.amount, movement.amount)
        XCTAssertEqual(mockMovement.date, movement.date)
        XCTAssertEqual(mockMovement.isPaid, movement.isPaid)
        XCTAssertEqual(mockMovement.storeId, movement.storeId)
        XCTAssertEqual(mockMovement.categoryId, movement.categoryId)
        XCTAssertEqual(mockMovement.paymentId, movement.paymentId)
    }
}
