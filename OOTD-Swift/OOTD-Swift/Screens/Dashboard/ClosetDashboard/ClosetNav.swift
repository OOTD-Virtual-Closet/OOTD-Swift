//
//  ClosetNav.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/22/24.
//

import SwiftUI

struct ClosetNav: View {
    @State private var selectedContent: Int? = 1
    var body: some View {
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

struct ClosetNav_Previews: PreviewProvider {
    static var previews: some View {
        ClosetNav()
    }
}
