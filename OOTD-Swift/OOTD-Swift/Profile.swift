//
//  Profile.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import Foundation


class Profile {
    let id: String
    let name: String
    let email: String
}

extension Profile {
    static var empty: Self {
        return Profile(
            id: "",
            name: "",
            email: ""
        )
    }
}
