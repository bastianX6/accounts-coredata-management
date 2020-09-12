//
//  DeleteOperation.swift
//
//
//  Created by Bastián Véliz Vega on 12-09-20.
//

import Combine
import CombineCoreData
import CoreData
import Foundation

class DeleteOperation {
    var persistentContainer: NSPersistentContainer
    var entityName = "AccountMovement"
    lazy var context: NSManagedObjectContext = {
        self.persistentContainer.newBackgroundContext()
    }()

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func delete(id: UUID) -> AnyPublisher<Void, Error> {
        let fetchRequest = NSFetchRequest<AccountMovement>(entityName: entityName)
        fetchRequest.setupWith(id: id)

        let publisher = self.context
            .fetchPublisher(fetchRequest)
            .tryMap { movements -> AccountMovement in
                guard let accountMovement = movements.first
                else {
                    throw CoreDataSourceError.noResults
                }
                return accountMovement
            }.tryMap { accountMovement -> Void in
                self.context.delete(accountMovement)
                try self.context.save()
            }.eraseToAnyPublisher()

        return publisher
    }
}
