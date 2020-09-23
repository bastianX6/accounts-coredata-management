//
//  MovementSumAdapter.swift
//
//
//  Created by Bastián Véliz Vega on 22-09-20.
//

import DataManagement
import Foundation

class MovementSumAdapter: MovementsSum {
    let id: UUID
    let sum: Float

    init?(dict: NSDictionary, type: MovementSumType) {
        guard let sum = dict["sum"] as? Float else { return nil }
        guard let id = dict[type.rawValue] as? UUID else { return nil }
        self.sum = sum
        self.id = id
    }
}

enum MovementSumType: String {
    case categoryId
    case storeId
    case paymentId
}
