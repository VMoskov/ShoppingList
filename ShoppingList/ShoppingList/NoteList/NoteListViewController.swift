//
//  NoteManager.swift
//  ShoppingList
//
//  Created by Vedran Moškov on 12.02.2024..
//

import Foundation
import UIKit

final class NoteListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var notesList = [NoteItem]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var notesListTableView: UITableView!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notesList = loadNotesList(forKey: "notesList") ?? []
        notesListTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveNotesList(notesList, forKey: "notesList")
    }
    
    // MARK: - Actions
    
    @IBAction func addNewNoteButtonHandler() {
        let addNewNoteStoryboard = UIStoryboard(name: "NoteManager", bundle: nil)
        let addNewNoteViewController = addNewNoteStoryboard.instantiateViewController(
            withIdentifier: String(describing: NoteManagerViewController.self)
        ) as! NoteManagerViewController
        
        navigationController?.pushViewController(addNewNoteViewController, animated: true)
    }
    
    // MARK: - Utility methods
    
    private func setUpTableView() {
        notesListTableView.rowHeight = UITableView.automaticDimension
        notesListTableView.dataSource = self
        notesListTableView.delegate = self
    }
    
}

// MARK: - Table View datasource

extension NoteListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoteListTableViewCell.self), for: indexPath) as! NoteListTableViewCell
        
        let note = notesList[indexPath.row]
        cell.configure(with: note)
        return cell
    }
    
}

// MARK: - Table View delegate

extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        pushEditItemViewController(forItemAtIndex: indexPath.row)
    }
    
}
