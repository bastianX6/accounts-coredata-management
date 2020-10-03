//
//  MockMovement.swift
//
//
//  Created by Bastián Véliz Vega on 12-09-20.
//

import DataManagement
import Foundation

struct MockMovement: Movement {
    var id: UUID = UUID()
    var name: String = ""
    var description: String = ""
    var amount: Float = 0
    var date: Date = Date()
    var isPaid: Bool = false
    var isPermanent: Bool = false
    var storeId: UUID = UUID()
    var categoryId: UUID = UUID()
    var paymentId: UUID?
}
