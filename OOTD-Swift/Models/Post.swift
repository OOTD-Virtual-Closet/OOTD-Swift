//
//  Post.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/17/24.
//
//

import Foundation
import SwiftUI

struct Post: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var owner: String?
    var caption: String?
    var image: String?
}
