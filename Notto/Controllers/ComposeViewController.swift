//
//  ComposeViewController.swift
//  Notto
//
//  Created by Juan Francisco Dorado Torres on 30/09/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

protocol ComposeDelegate: class {
  func compose(_ viewController: ComposeViewController, didAdd note: Note)
  func compose(_ viewController: ComposeViewController, didUpdate note: Note)
}

class ComposeViewController: UIViewController {

  // MARK: - Outlets

  @IBOutlet var textView: UITextView!
  @IBOutlet var saveBarButtonItem: UIBarButtonItem!

  // MARK: - Properties

  weak var delegate: ComposeDelegate?
  var noteToEdit: Note?

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    // handle keyboard behaviour
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    if let note = noteToEdit {
      textView.text = note.body
    }

    textView.becomeFirstResponder()
  }

  // MARK: - Actions

  @IBAction func saveBarButtonItemDidTap(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Save your note", message: "Add a title to save your note", preferredStyle: .alert)
    alert.addTextField { [weak self] (textField) in
      if let noteToEdit = self?.noteToEdit {
        textField.text = noteToEdit.title
      }
    }
    alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] (action) in
      if let title = alert.textFields?.first?.text, let body = self?.textView.text {
        if let strongSelf = self {
          if let noteToEdit = self?.noteToEdit {
            noteToEdit.title = title
            noteToEdit.body = body
            noteToEdit.updateDate()
            strongSelf.delegate?.compose(strongSelf, didUpdate: noteToEdit)
          } else {
            let newNote = Note(title: title, body: body)
            strongSelf.delegate?.compose(strongSelf, didAdd: newNote)
          }
        }

        self?.textView.resignFirstResponder()
        self?.dismiss(animated: true)
      }
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alert, animated: true)
  }

  @IBAction func cancelBarButtonItemDidTap(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }

  // MARK: - Methods

  @objc func adjustForKeyboard(notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
      return
    }

    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

    if notification.name == UIResponder.keyboardWillHideNotification {
      textView.contentInset = .zero
    } else {
      textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    }

    textView.scrollIndicatorInsets = textView.contentInset
    let selectedRange = textView.selectedRange
    textView.scrollRangeToVisible(selectedRange)
  }
}

extension ComposeViewController: UITextViewDelegate {

  func textViewDidChange(_ textView: UITextView) {
    saveBarButtonItem.isEnabled = textView.text != ""
  }
}
