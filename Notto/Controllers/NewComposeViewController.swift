//
//  NewComposeViewController.swift
//  Notto
//
//  Created by Juan Francisco Dorado Torres on 30/09/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

class NewComposeViewController: UIViewController {

  // MARK: - Outlets

  @IBOutlet var textView: UITextView!
  @IBOutlet var saveBarButtonItem: UIBarButtonItem!

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Actions

  @IBAction func saveBarButtonItemDidTap(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Save your note", message: "Add a title to save your note", preferredStyle: .alert)
    alert.addTextField()
    alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] (action) in
      if let title = alert.textFields?.first?.text, let body = self?.textView.text {
        print("Title: \(title)")
        print("Body: \(body)")
        let newNote = Note(title: title, body: body)
        self?.dismiss(animated: true)
      }
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alert, animated: true)
  }

  @IBAction func cancelBarButtonItemDidTap(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
}

extension NewComposeViewController: UITextViewDelegate {

  func textViewDidChange(_ textView: UITextView) {
    saveBarButtonItem.isEnabled = textView.text != ""
  }
}
