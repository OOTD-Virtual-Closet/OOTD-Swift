//
//  FavoritesView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

struct FavoritesView: View {
    @State var currentTab: Int = 0
    var body: some View {
        VStack {

                    Text("Favorites")
                        .foregroundColor(.black)
                        .font(.system( size: 25))
                        .fontWeight(.heavy)
                        .padding(.horizontal, 15)
                
            ZStack(alignment: .top) {
                TabView(selection: self.$currentTab) {
                    FavoriteClothes()
                        .tag(0)
                    FavoriteOutfits().tag(1)

                }
              TabBarView(currentTab: self.$currentTab)
            }
            
        }  
        .padding(.bottom, -100)
        .frame(maxHeight: .infinity)

        

    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
