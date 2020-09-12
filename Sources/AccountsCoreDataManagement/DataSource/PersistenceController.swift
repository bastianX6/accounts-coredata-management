//
//  PersistenceController.swift
//
//
//  Created by Bastián Véliz Vega on 12-09-20.
//

import CoreData
import Foundation
import Logging

class PersistenceController {
    // MARK: - Singletons

    static let shared = PersistenceController()

    // MARK: Previews singleton

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0 ..< 10 {
            let newItem = AccountMovement(context: viewContext)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            logger.info("Unresolved preview error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    // MARK: - CloudKit container

    let container: NSPersistentCloudKitContainer

    // MARK: - Private init

    private init(inMemory: Bool = false) {
        guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.module]) else {
            logger.critical("Couldn't load managedObjectModel")
            fatalError("Couldn't load managedObjectModel")
        }

        self.container = NSPersistentCloudKitContainer(name: "Account", managedObjectModel: managedObjectModel)
        if inMemory {
            self.container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        self.container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                logger.critical("CoreData Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
