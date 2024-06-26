//
//  OOTD_SwiftApp.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/8/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

@main
struct OOTD_SwiftApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      NavigationView {
          //Login()
          SplashScreenView()
              //.environmentObject(LogInVM())
//          ContentView()
//              .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
      }
      .environmentObject(LogInVM())
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
      func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
//          Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        return true
      }
      func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
          return GIDSignIn.sharedInstance.handle(url)
      }
}


