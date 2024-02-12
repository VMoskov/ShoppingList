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
    
    var noteIndex: Int?
    private var shoppingList = [ShoppingListItem]()
    private var notesList = [NoteItem]()
    private var linkedItems = [ShoppingListItem]()
    private var note: NoteItem?
    var edit: Bool = false
    
    // MARK: - Outlets
    
    @IBOutlet private weak var animatingView: UIStackView!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private  var noteTitleInputField: UITextField!
    @IBOutlet private weak var noteTextInputField: UITextView!
    @IBOutlet private weak var selectedItemsTableView: UITableView!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAddButton(enabled: edit)
        if edit {
            addButton.setTitle("Save", for: .normal)
            // check why the font is not working
            addButton.titleLabel?.font = UIFont(name: ".SFUI-Bold", size: 21.0)
        }
        setUpTableView()
        setUpNavigationBar()
//        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shoppingList = loadShoppingList(forKey: "shoppingList") ?? []
        notesList = loadNotesList(forKey: "notesList") ?? []
        if edit {
            note = notesList[noteIndex!]
            setUpInputFields()
        }
        
        selectedItemsTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveNotesList(notesList, forKey: "notesList")
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonHandler() {
        guard 
            let noteTitle = noteTitleInputField.text,
            !noteTitle.isEmpty
        else {
            shakeInputFields(forView: animatingView)
            let alert = UIAlertController(
                title: "Error",
                message: "Note title is mandatory!",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            return
        }
        let noteText = noteTextInputField.text ?? ""
        
        edit ? editNote(noteTitle, noteText) : addNote(noteTitle, noteText)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func itemPickerhandler() {
        let itemPickerStoryboard = UIStoryboard(name: "ItemPicker", bundle: nil)
        let itemPickerViewController = itemPickerStoryboard.instantiateViewController(
            withIdentifier: String(describing: ItemPickerViewController.self)
        ) as! ItemPickerViewController
        
        itemPickerViewController.delegate = self
        itemPickerViewController.selectedItemsIndexes = shoppingList.enumerated().filter { linkedItems.contains($0.element) }.map { $0.offset }
        let navigationController = UINavigationController(rootViewController: itemPickerViewController)
        present(navigationController, animated: true)
    }
    
    @IBAction func noteTitleEditingChanged() {
        guard noteTitleInputField.hasText else { return }
        setUpAddButton(enabled: true)
    }
    
    @IBAction func noteTitleEditingDidEnd() {
        guard !noteTitleInputField.hasText else { return }
        setUpAddButton(enabled: false)
    }
    
    @objc func goback(_ sender: UIBarButtonItem) {
        guard
            let noteTitle = noteTitleInputField.text,
            let noteText = noteTextInputField.text,
            !noteTitle.isEmpty || !noteText.isEmpty || linkedItems != []
        else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        if edit {
            let tmpText = note?.note == nil ? "" : note?.note
            let tmpItems = note?.linkedShoppingItems == nil ? [] : note?.linkedShoppingItems
            if noteTitle == note?.title && noteText == tmpText && linkedItems == tmpItems {
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
        guard let note, let noteIndex else { return }
        let alertController = UIAlertController(
            title: "Warning!",
            message: "Are you sure you want to delete \"\(note.title)\"?\nThis action can not be undone!",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            guard let self else { return }
            self.setUpAddButton(enabled: true)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self else { return }
            notesList.remove(at: noteIndex)
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Utility methods
    
    private func setUpTableView() {
        selectedItemsTableView.rowHeight = UITableView.automaticDimension
        selectedItemsTableView.dataSource = self
        selectedItemsTableView.delegate = self
    }
    
    private func setUpNavigationBar() {
        if edit { self.title = "Edit note" }
        setUpBackButton()
        if edit { setUpDeleteButton() }
    }
    
    private func setUpInputFields() {
        noteTitleInputField.text = note?.title
        noteTextInputField.text = note?.note
        linkedItems = note?.linkedShoppingItems ?? []
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
    
    private func setUpAddButton(enabled: Bool) {
        addButton.isEnabled = enabled
        addButton.alpha = enabled ? 1 : 0.5
    }
    
    private func addNote(_ noteTitle: String, _ noteText: String) {
        var newNote = NoteItem(title: noteTitle)
        newNote.note = noteText != "" ? noteText : nil
        newNote.linkedShoppingItems = !linkedItems.isEmpty ? linkedItems : nil
        notesList.append(newNote)
    }
    
    private func editNote(_ noteTitle: String, _ noteText: String) {
        guard var note, let noteIndex else { return }
        note.title = noteTitle
        note.note = noteText != "" ? noteText : nil
        note.linkedShoppingItems = !linkedItems.isEmpty ? linkedItems : nil
        notesList[noteIndex] = note
    }
    
}

// MARK: - Table View datasource

extension NoteManagerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        linkedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListTableViewCell.self), for: indexPath) as! ListTableViewCell
        
        let item = linkedItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
}

// MARK: - Table View delegate

extension NoteManagerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - Implement the protocol

extension NoteManagerViewController: SelectedIndexesDelegate {
    
    func didSelectItems(_ items: [ShoppingListItem]) {
        linkedItems = items
        selectedItemsTableView.reloadData()
    }
    
}
