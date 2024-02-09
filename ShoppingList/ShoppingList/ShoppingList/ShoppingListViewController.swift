//
//  ShoppingListController.swift
//  invariant
//
//  Created by Vedran Moškov on 08.02.2024..
//

import Foundation
import UIKit

final class ShoppingListViewController: UIViewController {
    
    // MARK: 
    
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    // MARK: - Properties
    
    private var shoppingList = [ShoppingListItem]()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test()
        setUpTableView()
    }
    
    // MARK: -Actions
    
    @IBAction func handleAddNewItemButton() {
        pushAddNewItemViewController()
        shoppingListTableView.reloadData()
    }
    
    // MARK: -Utility methods
    
    private func setUpTableView() {
        shoppingListTableView.rowHeight = UITableView.automaticDimension
        shoppingListTableView.dataSource = self
        shoppingListTableView.delegate = self
    }
    
    private func pushAddNewItemViewController() {
        let addNewItemStoryboard = UIStoryboard(name: "AddNewItem", bundle: nil)
        let addNewItemViewController = addNewItemStoryboard.instantiateViewController(withIdentifier: String(describing: AddNewItemViewController.self)) as! AddNewItemViewController
        
        let navigationController = UINavigationController(rootViewController: addNewItemViewController)
        present(navigationController, animated: true)
    }
    
    private func test() {
        let item = ShoppingListItem(name: "Item name", amount: 10)
        shoppingList.append(item)
    }
    
}

//MARK: -Table View datasource

extension ShoppingListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListTableViewCell.self), for: indexPath) as! ListTableViewCell
        
        let item = shoppingList[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
}

// MARK: -Table View delegate

extension ShoppingListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
