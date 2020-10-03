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
    @nonobjc class func fetchRequest() -> NSFetchRequest<AccountMovement> {
        return NSFetchRequest<AccountMovement>(entityName: "AccountMovement")
    }

    @NSManaged var amount: Float
    @NSManaged var categoryId: UUID?
    @NSManaged var date: Date?
    @NSManaged var id: UUID?
    @NSManaged var isPaid: Bool
    @NSManaged var isPermanent: Bool
    @NSManaged var movementDescription: String
    @NSManaged var name: String
    @NSManaged var paymentId: UUID?
    @NSManaged var storeId: UUID?
}
