//
//  User.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/21/24.
//

import Foundation
import SwiftUI

struct User: Codable, Identifiable {
    var id: String = UUID().uuidString
    var uid: String?
    var name: String?
    var email: String?
    var username: String?
    var clothes : [String]?
    var creationDate: Date?
}
