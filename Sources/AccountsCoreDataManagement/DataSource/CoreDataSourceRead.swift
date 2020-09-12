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
}
