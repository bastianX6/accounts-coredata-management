//
//  SaveOperation.swift
//
//
//  Created by Bastián Véliz Vega on 12-09-20.
//

import Combine
import CombineCoreData
import CoreData
import DataManagement
import Foundation

class SaveOperation {
    var persistentContainer: NSPersistentContainer
    var entityName = "AccountMovement"
    lazy var context: NSManagedObjectContext = {
        self.persistentContainer.newBackgroundContext()
    }()

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func save(movement: Movement) -> AnyPublisher<Void, Error> {
        let fetchRequest = NSFetchRequest<AccountMovement>(entityName: entityName)
        fetchRequest.setupWith(id: movement.id)

        let publisher = self.context
            .fetchPublisher(fetchRequest)
            .tryMap { movements -> Void in
                let accountMovement = movements.first ?? AccountMovement(context: self.context)
                accountMovement.updateWith(movement: movement)
                try self.context.save()
            }.eraseToAnyPublisher()

        return publisher
    }
}
