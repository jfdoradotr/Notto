//
//  NotesListViewController.swift
//  Notto
//
//  Created by Juan Francisco Dorado Torres on 30/09/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

class NotesListViewController: UITableViewController {

  // MARK: - Properties

  var notes = [Note]()

  struct Storyboard {

    struct Identifier {
      static let newCompose = "NewCompose"
      static let editCompose = "EditCompose"
    }

    struct Cell {
      struct Identifier {
        static let noteCell = "NoteCell"
      }
    }
  }

  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadData()
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? ComposeViewController {
      vc.delegate = self
      if segue.identifier == Storyboard.Identifier.editCompose, let noteToEdit = sender as? Note {
        vc.noteToEdit = noteToEdit
      }
    }
  }

  // MARK: - Methods

  func saveData() {
    let jsonEncoder = JSONEncoder()
    if let savedData = try? jsonEncoder.encode(notes) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "notes")
    } else {
      print("Failed to save notes.")
    }
  }

  func loadData() {
    let defaults = UserDefaults.standard
    if let savedNotes = defaults.object(forKey: "notes") as? Data {
      let jsonDecoder = JSONDecoder()
      do {
        notes = try jsonDecoder.decode([Note].self, from: savedNotes)
      } catch {
        print("Failed to load notes")
      }
    }
    tableView.reloadData()
  }
}

// MARK: - UITableView Delegates

extension NotesListViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.Cell.Identifier.noteCell, for: indexPath) as? NoteTableViewCell else {
      fatalError("")
    }

    cell.configureCell(notes[indexPath.row])

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selectedNote = notes[indexPath.row]
    performSegue(withIdentifier: Storyboard.Identifier.editCompose, sender: selectedNote)
  }
}

// MARK: - NewCompose Delegate

extension NotesListViewController: ComposeDelegate {

  func compose(_ viewController: ComposeViewController, didAdd note: Note) {
    notes.insert(note, at: 0)
    let newIndexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [newIndexPath], with: .automatic)
    saveData()
  }

  func compose(_ viewController: ComposeViewController, didUpdate note: Note) {
    let index = notes.firstIndex(of: note) ?? 0

    let currentIndexPath = IndexPath(row: index, section: 0)
    let newIndexPath = IndexPath(row: 0, section: 0)
    tableView.reloadRows(at: [currentIndexPath], with: .automatic)
    tableView.moveRow(at: currentIndexPath, to: newIndexPath)

    notes.remove(at: index)
    notes.insert(note, at: 0)

    saveData()
  }
}

