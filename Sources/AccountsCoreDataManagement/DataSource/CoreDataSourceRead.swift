//
//  CoreDataSourceRead.swift
//
//
//  Created by Bastián Véliz Vega on 11-09-20.
//

import Combine
import CombineCoreData
import CoreData
import DataManagement
import Foundation

/**
 CoreData read data source

 This class implements `DataSourceRead` and manage data using CoreData
 */
public class CoreDataSourceRead: DataSourceRead {
    var persistentContainer: NSPersistentContainer
    var entityName = "AccountMovement"

    /// Default initializer
    /// - Parameter persistentContainer: Core Data persistent container
    public init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    /**
     Convenience init

     This initializer uses `PersistenceController.shared.container` as persistent container
     */
    public convenience init() {
        self.init(persistentContainer: PersistenceController.shared.container)
    }

    /// Read a list of movements
    /// - Parameter query: query element
    /// - Returns: A publisher containing the fetch logic
    public func readMovements(query: ReadMovementsQuery) -> AnyPublisher<[Movement], Error> {
        let context = self.persistentContainer.newBackgroundContext()
        let fetchRequest = NSFetchRequest<AccountMovement>(entityName: entityName)
        fetchRequest.predicate = query.predicate

        let publisher = context
            .fetchPublisher(fetchRequest)
            .map { movements -> [Movement] in
                movements.compactMap { MovementAdapter(movement: $0) }
            }.eraseToAnyPublisher()

        return publisher
    }

    /// Read a single movement
    /// - Parameter id: movement id
    /// - Returns: A publisher containing the fetch logic
    public func readMovement(id: UUID) -> AnyPublisher<Movement, Error> {
        let context = self.persistentContainer.newBackgroundContext()

        let fetchRequest = NSFetchRequest<AccountMovement>(entityName: entityName)
        fetchRequest.setupWith(id: id)

        let publisher = context
            .fetchPublisher(fetchRequest)
            .tryMap { movements -> Movement in
                guard let accountMovement = movements.first,
                    let movement = MovementAdapter(movement: accountMovement) else {
                    throw CoreDataSourceError.noResults
                }
                return movement
            }.eraseToAnyPublisher()

        return publisher
    }

    /// Get the sum of movements grouped by category
    /// - Parameter query: query parameters
    /// - Returns: A publisher containing the fetch logic
    public func getMovementSumByCategory(query: ReadMovementsQuery) -> AnyPublisher<[MovementsSum], Error> {
        return self.getMovementSum(propertyType: .categoryId, query: query)
    }

    /// Get the sum of movements grouped by store
    /// - Parameter query: query parameters
    /// - Returns: A publisher containing the fetch logic
    public func getMovementSumByStore(query: ReadMovementsQuery) -> AnyPublisher<[MovementsSum], Error> {
        return self.getMovementSum(propertyType: .storeId, query: query)
    }

    /// Get the sum of movements grouped by store
    /// - Parameter propertyType: defines the property used in `group by`
    /// - Parameter query: query parameters
    /// - Returns: A publisher containing the fetch logic
    private func getMovementSum(propertyType: MovementSumType, query: ReadMovementsQuery) -> AnyPublisher<[MovementsSum], Error> {
        let context = self.persistentContainer.newBackgroundContext()
        let propertyToGroup = propertyType.rawValue

        let keypathExp = NSExpression(forKeyPath: "amount")
        let expression = NSExpression(forFunction: "sum:", arguments: [keypathExp])
        let sumDescription = NSExpressionDescription()
        sumDescription.expression = expression
        sumDescription.name = "sum"
        sumDescription.expressionResultType = .floatAttributeType

        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: entityName)
        fetchRequest.predicate = query.predicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToFetch = [sumDescription, propertyToGroup]
        fetchRequest.propertiesToGroupBy = [propertyToGroup]
        fetchRequest.resultType = .dictionaryResultType

        let publisher = context
            .fetchPublisher(fetchRequest)
            .map { movements -> [MovementsSum] in
                print("Movements: \(String(describing: movements))")
                return movements.compactMap { MovementSumAdapter(dict: $0, type: propertyType) }
            }.eraseToAnyPublisher()

        return publisher
    }
}
