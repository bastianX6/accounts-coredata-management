//
//  NSFetchRequest+Custom.swift
//
//
//  Created by Bastián Véliz Vega on 12-09-20.
//

import CoreData
import DataManagement
import Foundation

extension NSFetchRequest {
    @objc func setupWith(id: UUID) {
        self.fetchLimit = 1
        self.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
    }
}
