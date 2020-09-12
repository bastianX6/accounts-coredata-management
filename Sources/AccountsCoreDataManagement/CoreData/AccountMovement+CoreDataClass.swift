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
}
