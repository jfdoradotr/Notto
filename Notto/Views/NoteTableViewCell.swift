//
//  NoteTableViewCell.swift
//  Notto
//
//  Created by Juan Francisco Dorado Torres on 30/09/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

  // MARK: - Outlets

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var bodyLabel: UILabel!

  // MARK: - Methods

  func configureCell(_ note: Note) {
    titleLabel.text = note.title
    dateLabel.text = note.getDate()
    bodyLabel.text = note.body
  }
}
