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
        
        createMockData()
        setUpTableView()
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shoppingList = loadShoppingList(forKey: "shoppingList") ?? []
        shoppingListTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveShoppingList(shoppingList, forKey: "shoppingList")
    }
    
    // MARK: - Actions
    
    @IBAction func handleAddNewItemButton() {
        pushAddNewItemViewController()
        shoppingListTableView.reloadData()
    }
    
    @objc func pushNoteListViewController() {
        let noteListStoryboard = UIStoryboard(name: "NoteList", bundle: nil)
        let noteListViewController = noteListStoryboard.instantiateViewController(
            withIdentifier: String(describing: NoteListViewController.self)
        ) as! NoteListViewController
        
        navigationController?.pushViewController(noteListViewController, animated: true)
    }
    
    // MARK: - Utility methods
    
    private func setUpTableView() {
        shoppingListTableView.rowHeight = UITableView.automaticDimension
        shoppingListTableView.dataSource = self
        shoppingListTableView.delegate = self
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor(
            red: 67/255,
            green: 108/255,
            blue: 90/255,
            alpha: 1
        )
        setUpNotesButton()
    }
    
    private func setUpNotesButton() {
        let notesButton = UIBarButtonItem(title: "Notes", style: .plain, target: self, action: #selector(pushNoteListViewController))
        navigationItem.rightBarButtonItem = notesButton
    }
    
    private func pushAddNewItemViewController() {
        let addNewItemStoryboard = UIStoryboard(name: "ItemManager", bundle: nil)
        let addNewItemViewController = addNewItemStoryboard.instantiateViewController(
            withIdentifier: String(describing: ItemManagerViewController.self)
        ) as! ItemManagerViewController
        
        navigationController?.pushViewController(addNewItemViewController, animated: true)
    }
    
    private func pushEditItemViewController(forItemAtIndex index: Int) {
        let editItemStoryboard = UIStoryboard(name: "ItemManager", bundle: nil)
        let editItemViewController = editItemStoryboard.instantiateViewController(
            withIdentifier: String(describing: ItemManagerViewController.self)
        ) as! ItemManagerViewController
        
        editItemViewController.itemIndex = index
        editItemViewController.edit = true
        navigationController?.pushViewController(editItemViewController, animated: true)
    }
    
    private func createMockData() {
        let shoppingListItems: [ShoppingListItem] = [
            ShoppingListItem(name: "Apples", amount: 2.5),
            ShoppingListItem(name: "Milk", amount: 1.0),
            ShoppingListItem(name: "Bread", amount: 1.0),
            ShoppingListItem(name: "Banana", amount: 4)
        ]
        
        let noteItems: [NoteItem] = [
            NoteItem(title: "Fruit", note: "Amount is in kg", linkedShoppingItems: [shoppingListItems[0], shoppingListItems[3]]),
            NoteItem(title: "Pick up kids from school", note: "It finishes at 4pm"),
            NoteItem(title: "Water the plants")
        ]
        
        saveShoppingList(shoppingListItems, forKey: "shoppingList")
        saveNotesList(noteItems, forKey: "notesList")
    }
    
}

// MARK: - Table View datasource

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

// MARK: - Table View delegate

extension ShoppingListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pushEditItemViewController(forItemAtIndex: indexPath.row)
    }
    
}

extension UIViewController {
    
    func saveShoppingList(_ item: [ShoppingListItem], forKey key: String) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(item)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error encoding item: \(error)")
        }
    }
    
    func loadShoppingList(forKey key: String) -> [ShoppingListItem]? {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let item = try decoder.decode([ShoppingListItem].self, from: data)
                
                return item.sorted { (item1, item2) -> Bool in
                    if item1.name.lowercased() == item2.name.lowercased() {
                        return item1.id > item2.id
                    } else {
                        return item1.name.lowercased() < item2.name.lowercased()
                    }
                }
                
            } catch {
                print("Error decoding item: \(error)")
            }
        }
        return nil
    }
    
    func saveNotesList(_ item: [NoteItem], forKey key: String) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(item)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error encoding item: \(error)")
        }
    }
    
    func loadNotesList(forKey key: String) -> [NoteItem]? {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let item = try decoder.decode([NoteItem].self, from: data)
                
                return item.sorted { (item1, item2) -> Bool in
                    if item1.title.lowercased() == item2.title.lowercased() {
                        if item1.linkedShoppingItems?.count == item2.linkedShoppingItems?.count {
                            return item1.id > item2.id
                        } else {
                            return item1.linkedShoppingItems?.count ?? 0 > item2.linkedShoppingItems?.count ?? 0
                        }
                    } else {
                        return item1.title.lowercased() < item2.title.lowercased()
                    }
                }
                
            } catch {
                print("Error decoding item: \(error)")
            }
        }
        return nil
    }
    
    func shakeInputFields(forView animatingView: UIStackView) {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.07
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: animatingView.center.x - 10, y: animatingView.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: animatingView.center.x + 10, y: animatingView.center.y))
            
        animatingView.layer.add(shakeAnimation, forKey: "position")
    }
    
}
