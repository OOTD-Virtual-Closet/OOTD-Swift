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
    var email: String
    var creationDate: Date?
    var username: String?
    var clothesId: [String]?
    var outfitsId: [String]?
    var friendsId: [String]?
    var friendsRequestId: [String]?
    var postsId: [String]?
}
