//
//  NoteItem.swift
//  ShoppingList
//
//  Created by Vedran Moškov on 12.02.2024..
//

import Foundation

struct NoteItem: Codable {
    private static var idSequence = sequence(first: 1, next: { $0 + 1 })
    
    let id: Int
    var title: String
    var note: String?
    var linkedShoppingItems: [ShoppingListItem]?
    let creationDateTime: Date

    init(title: String, note: String? = nil, linkedShoppingItems: [ShoppingListItem]? = nil) {
        self.id = NoteItem.idSequence.next()!
        self.title = title
        self.note = note
        self.linkedShoppingItems = linkedShoppingItems
        self.creationDateTime = Date()
    }
}

extension NoteItem {
    mutating func removeLinkedItem(_ itemToRemove: ShoppingListItem) {
        if let index = linkedShoppingItems?.firstIndex(where: { $0.id == itemToRemove.id }) {
            linkedShoppingItems?.remove(at: index)
        }
    }
}

