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
    testData()
  }

  // MARK: - Methods

  func testData() {
    for i in 0...10 {
      let note = Note(title: "Note \(i)", body: "This is the body for the note \(1)")
      notes.append(note)
    }
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

