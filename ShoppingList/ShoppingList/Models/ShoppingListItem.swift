//
//  ShoppingListItem.swift
//  invariant
//
//  Created by Vedran Moškov on 08.02.2024..
//

import Foundation

struct ShoppingListItem {
    private static var idSequence = sequence(first: 1, next: { $0 + 1 })
    
    let id: Int
    let name: String
    let amount: Decimal
    let creationDateTime: Date

    init(name: String, amount: Decimal) {
        self.id = ShoppingListItem.idSequence.next()!
        self.name = name
        self.amount = amount
        self.creationDateTime = Date()
    }
}
