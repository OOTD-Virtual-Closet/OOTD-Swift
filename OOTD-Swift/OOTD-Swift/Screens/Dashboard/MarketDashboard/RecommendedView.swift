//
//  RecommendedView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

struct ClothingItemElements: Identifiable {
    var id: UUID = UUID()
    var name: String
    var image: String
    var price: String
    var description: String
}

struct RecommendedView: View {
    let trendingItems: [ClothingItemElements] = [
        ClothingItemElements(name: "Clothing 1", image: "clothing1", price: "$49.99", description: "A cool piece of clothing."),
        ClothingItemElements(name: "Clothing 2", image: "clothing2", price: "$59.99", description: "Another cool piece of clothing."),
        ClothingItemElements(name: "Clothing 3", image: "clothing3", price: "$39.99", description: "Yet another cool piece of clothing.")
    ]
    var body: some View {
        ScrollView {
            VStack {
                Text("Recommended")
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
                    VStack {
                        ForEach(trendingItems.prefix(2)) { item in
                            ImageCardView(item: item)
                                .padding(.bottom, 10)
                        }
                    }
                    
                    if trendingItems.count > 2 {
                        VStack {
                            Button(action: {
                                print("Keep button tapped")
                            }) {
                                Text("Keep")
                                // Styling
                            }
                            .padding(.bottom, 10)
                            
                            ImageCardView(item: trendingItems[2])
                            
                            Button(action: {
                                print("Like button tapped")
                            }) {
                                Text("Like")
                                // Styling
                            }
                            .padding(.top, 10)
                        }
                    }
                }
                .padding(.horizontal, 25)
            }
        }
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

struct ImageCardView: View {
    var item: ClothingItemElements
    @State private var showingDetail = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 135, height: 185)
                .cornerRadius(15)
                .onTapGesture {
                    self.showingDetail = true
                }
                .sheet(isPresented: $showingDetail) {
                    ClothingDetailSheet(item: item)
                }
            
            Button(action: {
                self.showingDetail = true
            }) {
                Text("Get Info")
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(Color.black.opacity(0.7))
                    .clipShape(Capsule())
            }
            .padding(.top, 10)
            .padding(.leading, 10)
        }
    }
}

struct ClothingDetailSheet: View {
    var item: ClothingItemElements
    var body: some View {
        VStack {
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
            
            Text(item.name)
                .font(.title)
                .padding()
            
            Text(item.price)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(item.description)
                .padding()
            
            Spacer()
        }
        .padding()
    }
}


struct RecommendedView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendedView()
    }
}
