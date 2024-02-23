//
//  MarketNav.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/22/24.
//

import SwiftUI

struct MarketNav: View {
    @State private var selectedContent: Int? = 1
    var body: some View {
        VStack {
            Text("Market")
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
                    Text("Categories")
                }
                Button(action: {
                    self.selectedContent = 2
                }) {
                    Text("Recommended")
                }
                Button(action: {
                    self.selectedContent = 3
                }) {
                    Text("Trending")
                }
            }
            Spacer()
            // Content views
            if selectedContent == 1 {
                CategoriesView()
            } else if selectedContent == 2 {
                RecommendedView()
            } else if selectedContent == 3 {
                TrendingView()
            }
            Spacer()
        }
        .padding()
        
    }
}

struct MarketNav_Previews: PreviewProvider {
    static var previews: some View {
        MarketNav()
    }
}
