//
//  AddNewItemViewController.swift
//  invariant
//
//  Created by Vedran Moškov on 08.02.2024..
//

import Foundation
import UIKit

final class AddNewItemViewController: UIViewController {
    
    var item: ShoppingListItem?
    
    // MARK: - Outlets
    
    @IBOutlet weak var itemAmountInputField: UITextField!
    @IBOutlet weak var itemNameInputField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAddButton(enabled: false)
    }
    
    // MARK: - Actions
    
    @IBAction func itemNameEditingChanged() {
        guard itemAmountInputField.hasText else { return }
        setUpAddButton(enabled: true)
    }
    
    @IBAction func itemNameEditingEnd() {
        guard
            let itemName = itemNameInputField.text,
            let itemAmount = itemAmountInputField.text,
            !itemName.isEmpty,
            !itemAmount.isEmpty
        else { return }
        setUpAddButton(enabled: false)
    }
    
    @IBAction func itemAmountEditingChanged() {
        guard itemNameInputField.hasText else { return }
        setUpAddButton(enabled: true)
    }
    
    @IBAction func itemAmountEditingEnd() {
        guard
            let itemName = itemNameInputField.text,
            let itemAmount = itemAmountInputField.text,
            !itemName.isEmpty,
            !itemAmount.isEmpty
        else { return }
        setUpAddButton(enabled: false)
    }
    
    @IBAction func addButtonHandler() {
        guard
            let itemName = itemNameInputField.text,
            let itemAmount = itemAmountInputField.text,
            !itemName.isEmpty,
            !itemAmount.isEmpty
        else {
            let alert = UIAlertController(
                title: "Error",
                message: "Item name and amount are mandatory!",
                 preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            return
        }
        
        var newItem = ShoppingListItem(name: itemName, amount: Decimal(string: itemAmount)!)
    }
    
    // MARK: - Utility methods
    
    private func setUpAddButton(enabled: Bool) {
        addButton.isEnabled = enabled
        addButton.alpha = enabled ? 1 : 0.5
    }
    
}
