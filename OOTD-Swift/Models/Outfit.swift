//
//  Outfit.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/1/24.
//

import Foundation

import SwiftUI

struct Outfit: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var genre: String
    var cloth1: String
    var cloth2: String
    var cloth3: String
    var cloth4: String
}
