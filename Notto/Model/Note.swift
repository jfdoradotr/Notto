//
//  Note.swift
//  Notto
//
//  Created by Juan Francisco Dorado Torres on 30/09/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

class Note: Codable {

  // MARK: - Properties

  private let id: String
  var title: String
  var body: String
  private(set) var date = Date()

  // MARK: - Constructor

  init(title: String, body: String) {
    self.id = UUID().uuidString
    self.title = title
    self.body = body
  }

  // MARK: - Methods

  func getDate() -> String {
    let format = DateFormatter()
    format.timeStyle = .none
    format.dateStyle = .short
    return format.string(from: date)
  }

  func updateDate() {
    date = Date()
  }
}

extension Note: Equatable {

  static func == (lhs: Note, rhs: Note) -> Bool {
    return lhs.id == rhs.id
  }
}
