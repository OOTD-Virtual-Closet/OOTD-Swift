//
//  ApplicationUtility.swift
//  OOTD-Swift
//
//  Created by Rishabh Pandey on 2/20/24.
//

import SwiftUI

final class ApplicationUtility {
    static var rootViewController: UIViewController {

        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }

        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }

        return root
    }
}
