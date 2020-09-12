//
//  AccountMovement+CoreDataClass.swift
//
//
//  Created by Bastián Véliz Vega on 12-09-20.
//
//

import CoreData
import DataManagement
import Foundation

@objc(AccountMovement)
public class AccountMovement: NSManagedObject {
    func getMovement() -> Movement? {
        return MovementAdapter(movement: self)
    }

    func updateWith(movement: Movement) {
        self.id = movement.id
        self.name = movement.name
        self.movementDescription = movement.description
        self.amount = movement.amount
        self.date = movement.date
        self.isPaid = movement.isPaid
        self.storeId = movement.storeId
        self.categoryId = movement.categoryId
        self.paymentId = movement.paymentId
    }
}
