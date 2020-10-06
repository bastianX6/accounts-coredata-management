//
//  MovementAdapter.swift
//
//
//  Created by Bastián Véliz Vega on 12-09-20.
//

import DataManagement
import Foundation

struct MovementAdapter: Movement {
    let id: UUID
    let name: String
    let description: String
    let amount: Float
    let date: Date
    let isPaid: Bool
    let isPermanent: Bool
    let storeId: UUID
    let categoryId: UUID
    let paymentId: UUID?

    init?(movement: AccountMovement) {
        guard let id = movement.id,
            let date = movement.date,
            let storeId = movement.storeId,
            let categoryId = movement.categoryId else { return nil }

        self.id = id
        self.name = movement.name
        self.description = movement.movementDescription
        self.amount = movement.amount
        self.date = date
        self.isPaid = movement.isPaid
        self.isPermanent = movement.isPermanent
        self.storeId = storeId
        self.categoryId = categoryId
        self.paymentId = movement.paymentId
    }
}
