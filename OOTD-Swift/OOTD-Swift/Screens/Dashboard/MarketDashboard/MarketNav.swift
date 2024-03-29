//
//  MarketNav.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/22/24.
//

import SwiftUI

struct MarketNav: View {
    @State private var selectedContent: Int? = 1
    @Binding var isAuthenticated:Bool
    var tabImageNames : [String] = ["square.stack", "hand.thumbsup", "flame"]
    var tabBarOptions: [String] = ["Categories", "Trending"]
    @State var currentTab: Int = 0

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    ZStack (alignment: .top) {
                        TabView(selection: self.$currentTab) {
                            CategoriesView()
                                .tag(0)
                           TrendingView().tag(1)
                            
                        }.padding (.top, 50)
                        TabBarViewV2(currentTab: self.$currentTab, tabBarOptions: tabBarOptions, tabBarImages: tabImageNames, spacing: 40)
                    }
                    Spacer()
                }
                .padding(.bottom, -100)
                
            }

            }
        }
    }


struct MarketNav_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        MarketNav(isAuthenticated: $isAuthenticated)
    }
}
