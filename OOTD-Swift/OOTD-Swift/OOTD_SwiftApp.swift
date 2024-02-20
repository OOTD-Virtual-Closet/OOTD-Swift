//
//  OOTD_SwiftApp.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/8/24.
//

import SwiftUI

@main
struct OOTD_SwiftApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
              //.environmentObject(LogInVM())
              .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
      }
    }
  }
}

