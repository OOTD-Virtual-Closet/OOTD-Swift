//
//  ClosetNav.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/22/24.
//

import SwiftUI

struct ClosetNav: View {
    @State private var selectedContent: Int? = 1
    @Binding var isAuthenticated:Bool
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack{
                HStack{
                    Spacer()
                    NavigationLink(destination: ProfileSummary(isAuthenticated: $isAuthenticated)) {
                        Image("UserIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .border(Color.gray)
                            .padding(.trailing)
                    }
                }
                Spacer()
            }
            VStack {
                Text("Closet")
                    .foregroundStyle(Color(hex:"898989"))
                    .font(.title3)
                    .fontWeight(.heavy)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black)
                HStack{
                    // Buttons to select content
                    Button(action: {
                        self.selectedContent = 1
                    }) {
                        Text("Clothes")
                    }
                    Spacer()
                    Button(action: {
                        self.selectedContent = 2
                    }) {
                        Text("Outfits")
                    }
                    Spacer()
                    Button(action: {
                        self.selectedContent = 3
                    }) {
                        Text("Favorites")
                    }
                }
                Spacer()
                // Content views
                if selectedContent == 1 {
                    ClothesView()
                } else if selectedContent == 2 {
                    OutfitsView()
                } else if selectedContent == 3 {
                    FavoritesView()
                }
                Spacer()
            }
            .padding()
            
        }
    }
}

struct ClosetNav_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        ClosetNav(isAuthenticated: $isAuthenticated)
    }
}
