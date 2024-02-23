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
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    // Action for settings button
                    // You can present a settings view here
                    ProfileSummary(isAuthenticated: $isAuthenticated)
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 5)
                .padding()
            }
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
}

struct DashboardNav_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        DashboardNav(isAuthenticated: $isAuthenticated, userProfile: "im not adi")
    }
}
