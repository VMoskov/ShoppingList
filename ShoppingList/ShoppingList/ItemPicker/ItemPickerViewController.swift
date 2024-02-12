//
//  ItemPickerViewController.swift
//  ShoppingList
//
//  Created by Vedran Moškov on 11.02.2024..
//

import Foundation
import UIKit

// MARK: - Protocol

protocol SelectedIndexesDelegate: AnyObject {
    func didSelectItems(_ items: [ShoppingListItem])
}

final class ItemPickerViewController: UIViewController {
    
    // MARK: - Properties
    
    private var shoppingList = [ShoppingListItem]()
    private var filteredItems = [ShoppingListItem]()
    var selectedItemsIndexes = [Int]()
    var delegate: SelectedIndexesDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var shoppingListTableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shoppingList = loadShoppingList(forKey: "shoppingList") ?? []
        filteredItems = shoppingList
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.didSelectItems(shoppingList.enumerated().filter { selectedItemsIndexes.contains($0.offset) }.map { $0.element })
    }
    
    
    // MARK: - Actions
    
    @IBAction func searchBarEditingDidBegin() {
        searchBar.text = ""
        searchBar.textColor = UIColor.black
    }
    
    @IBAction func searchBarDidChange() {
        filterItems()
    }
    
    
    @objc func dismissScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Utility methods
    
    private func setUpTableView() {
        shoppingListTableView.rowHeight = UITableView.automaticDimension
        shoppingListTableView.dataSource = self
        shoppingListTableView.delegate = self
        shoppingListTableView.allowsMultipleSelection = true
    }
    
    private func setUpNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(dismissScreen)
        )
        navigationItem.leftBarButtonItem?.tintColor = UIColor(
            red: 67/255.0,
            green: 108/255.0,
            blue: 90/255.0,
            alpha: 1.0
        )
    }
    
    private func filterItems() {
            guard let searchText = searchBar.text, !searchText.isEmpty else {
                filteredItems = shoppingList
                shoppingListTableView.reloadData()
                return
            }
            
            filteredItems = shoppingList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            shoppingListTableView.reloadData()
        }
    
}

//MARK: - Table View datasource

extension ItemPickerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListTableViewCell.self), for: indexPath) as! ListTableViewCell
        
        let item = filteredItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
}

// MARK: - Table View delegate

extension ItemPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedItemsIndexes.append(indexPath.row)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray
        if selectedItemsIndexes.contains(indexPath.row) {
            selectedItemsIndexes.removeAll { $0 == indexPath.row }
        }
        else {
            selectedItemsIndexes.append(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        selectedItemsIndexes.removeAll { $0 == indexPath.row }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.white
        if selectedItemsIndexes.contains(indexPath.row) {
            selectedItemsIndexes.removeAll { $0 == indexPath.row }
        }
        else {
            selectedItemsIndexes.append(indexPath.row)
        }
    }
    
}
