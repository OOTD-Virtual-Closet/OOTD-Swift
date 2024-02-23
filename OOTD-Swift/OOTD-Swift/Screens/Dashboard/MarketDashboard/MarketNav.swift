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
    var body: some View {
        // Navigation link must be embedded inside a nav stack
        NavigationStack {
            ZStack {
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
                        Spacer()
                        Button(action: {
                            self.selectedContent = 2
                        }) {
                            Text("Recommended")
                        }
                        Spacer()
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
    }
}

struct MarketNav_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        MarketNav(isAuthenticated: $isAuthenticated)
    }
}
