//
//  AddNewItemViewController.swift
//  invariant
//
//  Created by Vedran Moškov on 08.02.2024..
//

import Foundation
import UIKit


final class ItemManagerViewController: UIViewController {
    
    // MARK: - Properties
    
    private var shoppingList = [ShoppingListItem]()
    private var item: ShoppingListItem?
    var itemIndex: Int?
    var edit: Bool = false
    
    // MARK: - Outlets
    
    @IBOutlet private weak var animatingView: UIStackView!
    @IBOutlet private weak var itemAmountInputField: UITextField!
    @IBOutlet private weak var itemNameInputField: UITextField!
    @IBOutlet private weak var addButton: UIButton!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAddButton(enabled: false)
        if edit {
            addButton.setTitle("Save", for: .normal)
            // check why the font is not working
            addButton.titleLabel?.font = UIFont(name: ".SFUI-Bold", size: 21.0)
        }
        setUpNavigationBar()
//        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shoppingList = loadShoppingList(forKey: "shoppingList") ?? []
        shoppingList = shoppingList.sorted { (item1, item2) -> Bool in
            if item1.name == item2.name {
                return item1.id > item2.id // Sort by id in descending order if names are equal
            } else {
                return item1.name < item2.name // Sort by name in ascending order
            }
        }
        if edit {
            item = shoppingList[itemIndex!]
            setUpInputFields()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveShoppingList(shoppingList, forKey: "shoppingList")
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
            shakeInputFields(forView: animatingView)
            let alert = UIAlertController(
                title: "Error",
                message: "Item name and amount are mandatory!",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            return
        }
        
        edit ? editItem(itemName, itemAmount) : addNewItem(itemName, itemAmount)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func goback(_ sender: UIBarButtonItem) {
        guard
            let itemName = itemNameInputField.text,
            let itemAmount = itemAmountInputField.text,
            !itemName.isEmpty || !itemAmount.isEmpty
        else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        if edit {
            if itemName == item?.name && Decimal(string: itemAmount) == item?.amount {
                navigationController?.popViewController(animated: true)
                return
            }
        }
        
        let alertController = UIAlertController(
            title: "Warning!",
            message: "Are you sure you want to discard the changes?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            guard let self else { return }
            self.setUpAddButton(enabled: true)
        }
        
        let discardAction = UIAlertAction(title: "Discard", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }
            
        alertController.addAction(cancelAction)
        alertController.addAction(discardAction)
            
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func deleteItem(_ sender: UIBarButtonItem) {
        guard let item, let itemIndex else { return }
        let alertController = UIAlertController(
            title: "Warning!",
            message: "Are you sure you want to delete \"\(item.name)\"?\nThis action can not be undone!",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            guard let self else { return }
            self.setUpAddButton(enabled: true)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self else { return }
            shoppingList.remove(at: itemIndex)
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Utility methods
    
    private func setUpAddButton(enabled: Bool) {
        addButton.isEnabled = enabled
        addButton.alpha = enabled ? 1 : 0.5
    }
    
    private func setUpNavigationBar() {
        if edit { self.title = "Edit item" }
        setUpBackButton()
        if edit { setUpDeleteButton() }
    }
    
    private func setUpInputFields() {
        itemNameInputField.text = item?.name
        itemAmountInputField.text = "\(item?.amount ?? 0)"
    }
    
    private func addNewItem(_ itemName: String, _ itemAmount: String) {
        let newItem = ShoppingListItem(name: itemName, amount: Decimal(string: itemAmount)!)
        shoppingList.append(newItem)
    }
    
    private func editItem(_ itemName: String, _ itemAmount: String) {
        guard var item, let itemIndex else { return }
        item.name = itemName
        item.amount = Decimal(string: itemAmount)!
        shoppingList[itemIndex] = item
    }
    
    private func setUpBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        backButton.sizeToFit()

        backButton.addTarget(self, action: #selector(goback(_:)), for: .touchUpInside)

        let backButtonBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonBarButtonItem
    }
    
    private func setUpDeleteButton() {
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        deleteButton.tintColor = UIColor.red
        deleteButton.sizeToFit()
        
        deleteButton.addTarget(self, action: #selector(deleteItem(_:)), for: .touchUpInside)
        
        let deleteButtonBarButtonItem = UIBarButtonItem(customView: deleteButton)
        navigationItem.rightBarButtonItem = deleteButtonBarButtonItem
    }
    
}
