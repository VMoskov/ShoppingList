//
//  ShoppingListItem.swift
//  invariant
//
//  Created by Vedran Moškov on 08.02.2024..
//

import Foundation

struct ShoppingListItem: Codable, Equatable {
    private static var idSequence = sequence(first: 1, next: { $0 + 1 })
    
    let id: Int
    var name: String
    var amount: Decimal
    let creationDateTime: Date

    init(name: String, amount: Decimal) {
        self.id = ShoppingListItem.idSequence.next()!
        self.name = name
        self.amount = amount
        self.creationDateTime = Date()
    }
    
    static func == (lhs: ShoppingListItem, rhs: ShoppingListItem) -> Bool {
        return lhs.name == rhs.name &&
               lhs.amount == rhs.amount &&
               lhs.id == rhs.id &&
               lhs.creationDateTime == rhs.creationDateTime
        }
}
