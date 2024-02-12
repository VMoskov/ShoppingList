//
//  NoteListTableViewCell.swift
//  ShoppingList
//
//  Created by Vedran Moškov on 12.02.2024..
//

import Foundation
import UIKit

final class NoteListTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var linkedItemsCountLabel: UILabel!
    
    // MARK: - Utility methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with note: NoteItem) {
        titleLabel.text = note.title
        noteLabel.text = "Note: \(note.note ?? "-")"
        linkedItemsCountLabel.text = "Linked items: \(note.linkedShoppingItems?.count ?? 0)"
    }
}
