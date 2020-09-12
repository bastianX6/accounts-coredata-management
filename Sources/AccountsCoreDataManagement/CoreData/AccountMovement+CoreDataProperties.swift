//
//  AccountMovement+CoreDataProperties.swift
//
//
//  Created by Bastián Véliz Vega on 12-09-20.
//
//

import CoreData
import Foundation

extension AccountMovement {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountMovement> {
        return NSFetchRequest<AccountMovement>(entityName: "AccountMovement")
    }

    @NSManaged public var amount: Float
    @NSManaged public var categoryId: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isPaid: Bool
    @NSManaged public var movementDescription: String
    @NSManaged public var name: String
    @NSManaged public var paymentId: UUID?
    @NSManaged public var storeId: UUID?
}
