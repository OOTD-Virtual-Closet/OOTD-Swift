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
    var uid: String
    var name: String?
    var username: String?
    var email: String
    var creationDate: Date?
    var clothes: [String?]?
    var outfits: [String?]?
    var friends: [String?]?
    var friendRequestsSent: [String?]?
    var friendRequestsReceived: [String?]?
    var postsId: [String?]?
    var favorites: [String?]?
    var favoriteFits: [String?]?
    var pinnedFits: [String?]?
}
