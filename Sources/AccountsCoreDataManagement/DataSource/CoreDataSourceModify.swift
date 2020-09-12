//
//  CoreDataSourceModify.swift
//
//
//  Created by Bastián Véliz Vega on 12-09-20.
//

import Combine
import CombineCoreData
import CoreData
import DataManagement
import Foundation

/**
 CoreData modify data source

 This class implements `DataSourceModify` and manage data using CoreData
 */
public class CoreDataSourceModify: DataSourceModify {
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

    /// Save a new movement
    /// - Parameter movement: movement to be saved
    /// - Returns: A publisher containing the save logic
    public func save(movement: Movement) -> AnyPublisher<Void, Error> {
        let saveOperation = SaveOperation(persistentContainer: self.persistentContainer)
        return saveOperation.save(movement: movement)
    }

    /// Delete  a movement
    /// - Parameter movement: movement to be deleted
    /// - Returns: A publisher containing the delete logic
    public func delete(movement: Movement) -> AnyPublisher<Void, Error> {
        let deleteOperation = DeleteOperation(persistentContainer: self.persistentContainer)
        return deleteOperation.delete(id: movement.id)
    }

    /// Update an existing movement
    /// - Parameter movement: movement to be saved
    /// - Returns: A publisher containing the fetch and save logic
    public func update(movement: Movement) -> AnyPublisher<Void, Error> {
        let updateOperation = SaveOperation(persistentContainer: self.persistentContainer)
        return updateOperation.save(movement: movement)
    }
}
