//
//  OOTD_SwiftApp.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/8/24.
//

import SwiftUI

@main
struct OOTD_SwiftApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
