//
//  MockPersistantContainer.swift
//
//
//  Created by Bastián Véliz Vega on 12-09-20.
//

@testable import AccountsCoreDataManagement
import CombineCoreData
import CoreData
import Foundation

class MockPersistantContainer {
    static let shared = MockPersistantContainer()

    private init() {}

    private let entities: [String] = [
        "AccountMovement"
    ]

    let accountPaymentEntity = "AccountMovement"

    private var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.module])!
        return managedObjectModel
    }()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataUnitTesting", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSSQLiteStoreType
        description.configuration = "Default"
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { storeDescription, error in
            precondition(storeDescription.type == NSSQLiteStoreType)
            if let error = error {
                fatalError("Error loading persistent stores: \(String(describing: error))")
            } else {
                debugPrint("Store description: \(storeDescription)")
            }
        }
        return container
    }()

    func deleteAll() throws {
        try self.entities.forEach { name in
            try self.deleteEntity(name: name)
        }
    }

    private func deleteEntity(name: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.returnsObjectsAsFaults = false

        let publisher = self.container.viewContext
            .fetchPublisher(fetchRequest)
            .tryMap { elements -> Void in
                elements.forEach {
                    guard let objectData = $0 as? NSManagedObject else { return }
                    self.container.viewContext.delete(objectData)
                }
                try self.container.viewContext.save()
            }.eraseToAnyPublisher()

        let result = publisher.wait(timeout: 5)

        guard let error = result.error else { return }
        throw error
    }
}
