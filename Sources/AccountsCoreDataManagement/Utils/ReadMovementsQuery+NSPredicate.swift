//
//  ReadMovementsQuery+NSPredicate.swift
//
//
//  Created by Bastián Véliz Vega on 12-09-20.
//

import DataManagement
import Foundation

extension ReadMovementsQuery {
    var predicate: NSPredicate {
        var predicates: [NSPredicate] = []

        if let storeId = self.storeId {
            let predicate = NSPredicate(format: "%K == %@", "storeId", storeId as CVarArg)
            predicates.append(predicate)
        }

        if let categoryId = self.categoryId {
            let predicate = NSPredicate(format: "%K == %@", "categoryId", categoryId as CVarArg)
            predicates.append(predicate)
        }

        if let paymentId = self.paymentId {
            let predicate = NSPredicate(format: "%K == %@", "paymentId", paymentId as CVarArg)
            predicates.append(predicate)
        }

        let startDatePredicate = NSPredicate(format: "date >= %@", self.fromDate as NSDate)
        let endDatePredicate = NSPredicate(format: "date < %@", self.toDate as NSDate)

        predicates.append(startDatePredicate)
        predicates.append(endDatePredicate)

        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        return compoundPredicate
    }
}
