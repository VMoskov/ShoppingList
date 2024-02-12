//
//  NoteManagerViewController.swift
//  ShoppingList
//
//  Created by Vedran Moškov on 12.02.2024..
//

import Foundation
import UIKit

final class NoteManagerViewController: UIViewController {
    
    // MARK: - Properties
    
    private var noteIndex: Int?
    private var shoppingList = [ShoppingListItem]()
    private var notesList = [NoteItem]()
    private let linkedItems = [ShoppingListItem]()
    
    // MARK: - Outlets
    
    // MARK: - Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shoppingList = loadShoppingList(forKey: "shoppingList") ?? []
        notesList = loadNotesList(forKey: "notesList") ?? []
        // TableView.reloadData()
    }
    
    // MARK: - Actions
    
    // MARK: - Utility methods
}
