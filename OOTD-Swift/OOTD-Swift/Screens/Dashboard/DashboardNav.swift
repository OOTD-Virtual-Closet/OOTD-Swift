//
//  DashboardNav.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

// If User logged IN --> View this --> Redirect to the 3 view panels
struct DashboardNav: View {
    @Binding var isAuthenticated:Bool
    @State private var selectedTab = 1
    
    let userProfile: String
    var body: some View {
        NavigationView {
            
            VStack(spacing: 0) {
   
                       switch selectedTab {
                       case 1:
                           MarketNav(isAuthenticated: $isAuthenticated)
                       case 2:
                           SocialNav(isAuthenticated: $isAuthenticated)
                       case 3:
                           ClosetNav(isAuthenticated: $isAuthenticated)
                       default:
                           SocialNav(isAuthenticated: $isAuthenticated)
                       }
                       
                       Spacer()
                       
                       BottomNavBar(isAuthenticated: $isAuthenticated, selectedTab: $selectedTab)
                    
                   }
                   .navigationBarHidden(true)
               }            .ignoresSafeArea(.all)
            .padding(.top, -125)
    }
}

struct DashboardNav_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        @State var selectedTab = 1
        DashboardNav(isAuthenticated: $isAuthenticated, userProfile: "im not adi")
            .environmentObject(LogInVM())
    }
}
