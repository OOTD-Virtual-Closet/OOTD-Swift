//
//  OOTD_SwiftApp.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/8/24.
//

import SwiftUI
<<<<<<< HEAD
=======
import Firebase
import FirebaseAuth
import GoogleSignIn
>>>>>>> dev

@main
struct OOTD_SwiftApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      NavigationView {
<<<<<<< HEAD
        ContentView()
              //.environmentObject(LogInVM())
              .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
=======
          //Login()
          SplashScreenView()
//          ContentView()
//              .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
>>>>>>> dev
      }
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
      func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
      }
      func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
          return GIDSignIn.sharedInstance.handle(url)
      }
}


