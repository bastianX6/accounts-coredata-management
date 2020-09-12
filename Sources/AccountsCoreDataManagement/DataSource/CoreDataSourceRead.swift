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

public class CoreDataSourceRead: DataSourceRead {
    public var persistentContainer: NSPersistentContainer
    public var entityName = "AccountMovement"

    public init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

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

    public func readMovement(id: UUID) -> AnyPublisher<Movement, Error> {
        let context = self.persistentContainer.newBackgroundContext()

        let fetchRequest = NSFetchRequest<AccountMovement>(entityName: entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)

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
