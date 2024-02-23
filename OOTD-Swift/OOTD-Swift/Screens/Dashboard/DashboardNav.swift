//
//  DashboardNav.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

struct DashboardNav: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isAuthenticated:Bool
    
    let userProfile: String
    var body: some View {
        TabView {
            CategoriesView()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Market")
            }
            FeedView()
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Social")
            }
            ClothesView()
                .tabItem {
                    Image(systemName: "3.circle")
                    Text("Closet")
            }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct DashboardNav_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        DashboardNav(isAuthenticated: $isAuthenticated, userProfile: "im not adi")
    }
}
