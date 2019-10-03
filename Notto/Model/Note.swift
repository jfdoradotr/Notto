//
//  Note.swift
//  Notto
//
//  Created by Juan Francisco Dorado Torres on 30/09/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

struct Note: Codable {

  // MARK: - Properties

  var title: String
  var date = Date()
  var body: String
}
