//
//  ContentView.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/8/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @State private var isAuthenticated = false
    @State var userProfile = ""
    //TODO: make a class to store user info after auth
    var body: some View {
        @State var showSignInView:Bool = false
        NavigationView {
            if isAuthenticated {
                
                DashboardNav(isAuthenticated:$isAuthenticated,userProfile: userProfile)
            } else {
                Login(isAuthenticated:$isAuthenticated)
                    .environmentObject(LogInVM())
            }
        }
    
    }
}
//checks if quick login is enabled
func checkQuickLogin() -> Bool {
    // TODO: implement checkQuickLogin()
    return false;
}

//checks if biometric login is enabled
//returns true/false
func checkBiometricLogin() -> Bool {
    // TODO: implement checkBiometricLogin()
    return false;
}


struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
