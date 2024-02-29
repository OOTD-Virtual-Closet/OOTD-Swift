//
//  TrendingView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

struct TrendingView: View {
    let trendingItems = ["clothing1", "clothing2", "clothing3"]
    var body: some View {
        ScrollView {
            VStack {
                Text("Trending 🔥")
                    .font(.system( size: 25))
                    .fontWeight(.heavy)
                    .padding(.top, 8)
                Text("36 items")
                    .foregroundColor(.gray)
                    .font(.system( size: 13))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.leading, 10)
                    .padding(.top, 5)
                HStack {
                    Image(systemName: "cart.fill")
                    Text("Shopping Cart")
                        .foregroundColor(.black)
                        .font(.system( size: 18))
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 15)
                }
                .padding(.leading, 35)
                .padding(.bottom, 15)
                HStack(alignment: .top, spacing: 40) {
                    VStack() {
                        ForEach(trendingItems.prefix(2), id: \.self) { item in
                            imageCard(item: item)
                                .padding(.bottom, 10)
                        }
                    }
                    
                    if trendingItems.count > 2 {
                        VStack {
                            Button(action: {
                                print("Top button tapped")
                            }) {
                                Text("Keep")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color(hex:"489FB5"))
                                    .cornerRadius(15)
                            }
                            .padding(.bottom, 10)
                            imageCard(item: trendingItems[2])
                            Button(action: {
                                print("Top button tapped")
                            }) {
                                Text("Like")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color(hex:"FFBA49"))
                                    .cornerRadius(15)
                            }
                            .padding(.top, 10)
                        }
                    }
                }
                .padding(.horizontal, 25)
            }
        }.disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    }
}

@ViewBuilder
func imageCard(item: String) -> some View {
    ZStack(alignment: .topLeading) {
        // Background image
        Image(item)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 135, height: 185)
            .cornerRadius(15)
        
        // Get Info button
        Button(action: {
            print("Get Info tapped for")
        }) {
            Text("Get Info")
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color.black.opacity(0.7))
                .cornerRadius(15)
        }
        .padding(.top, 10)
        .padding(.leading, 10)
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}
