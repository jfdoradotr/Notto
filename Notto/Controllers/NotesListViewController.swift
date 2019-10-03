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

  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadData()
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "NewComposeViewController",
      let vc = segue.destination as? NewComposeViewController {
      vc.delegate = self
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteTableViewCell else {
      fatalError("")
    }

    cell.configureCell(notes[indexPath.row])

    return cell
  }
}

// MARK: - NewCompose Delegate

extension NotesListViewController: NewComposeDelegate {

  func newCompose(_ viewController: NewComposeViewController, didAddNewNote note: Note) {
    notes.append(note)
    let newIndexPath = IndexPath(row: notes.count - 1, section: 0)
    tableView.insertRows(at: [newIndexPath], with: .automatic)

    saveData()
  }
}

