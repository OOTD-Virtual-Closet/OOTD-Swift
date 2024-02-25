//
//  FavoriteOutfits.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/25/24.
//

import SwiftUI
struct FavoriteOutfits: View {
    let items = (1...10).map { "Item \($0)" }
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
                ForEach(items, id: \.self) { item in
                    Outfits(item: item)
                }
            }
            .padding(15)
        }
        .padding(.top, 40)
        .ignoresSafeArea(.all)
        
    }
}
struct FavoriteOutfitsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteOutfits()
    }
}
