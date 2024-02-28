//
//  Cloth.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/28/24.
//

import Foundation
import SwiftUI

struct Cloth: Codable, Identifiable {
    var id: String = UUID().uuidString
    var type: String?
    var size: String?
    var color: String?
    var brand: String?
    var image: Date?
    var tags: [String]?
}
