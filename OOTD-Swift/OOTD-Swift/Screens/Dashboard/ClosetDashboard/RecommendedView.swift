//
//  TrendingView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

struct RecommendedView: View {
    @State private var currentIndex = 0
    @State private var isExpanded = false
    let trendingItems: [ClothingItemElements] = [
        ClothingItemElements(name: "Clothing 1", descrption: "Otton shirt. Classic sollar. Short sleeve. Cuts at the Bottoms. Button close on the front.", image: "clothing1", price: "$49.99", description: "A cool piece of clothing.", color: "#33673B"),
        ClothingItemElements(name: "Clothing 2",descrption: "Otton shirt. Classic sollar. Short sleeve. Cuts at the Bottoms. Button close on the front.", image: "clothing2", price: "$59.99", description: "Another cool piece of clothing.", color: "#3E8989"),
        ClothingItemElements(name: "Clothing 3",descrption: "Otton shirt. Classic sollar. Short sleeve. Cuts at the Bottoms. Button close on the front.", image: "clothing3", price: "$39.99", description: "Yet another cool piece of clothing.", color: "#D1B490")
    ]
    var body: some View {
        VStack {
            Text("Recommended Outfits")
                .foregroundColor(.black)
                .font(.system(size: 20))
                .fontWeight(.heavy)
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                VStack {
                    Image(trendingItems[currentIndex].image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 180, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    
                    if isExpanded {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(trendingItems[currentIndex].name)
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                    .padding(.top, 10)
                                
                                Text(trendingItems[currentIndex].price)
                                    .fontWeight(.heavy)
                                
                                Text(trendingItems[currentIndex].descrption)
                                    .fontWeight(.medium)
                                
                                Text("Color")
                                    .font(.title3)
                                    .fontWeight(.heavy)
                                
                                Circle()
                                    .fill(Color(hex: trendingItems[currentIndex].color))
                                    .frame(width: 24, height: 24)
                                
                                Text("Size")
                                    .font(.title3)
                                    .fontWeight(.heavy)
                                
                                HStack {
                                    ForEach(["XS", "S", "M", "L", "XL"], id: \.self) { size in
                                        Circle()
                                            .foregroundColor(Color(hex: "F6F6F6"))
                                            .overlay(
                                                Text(size)
                                                    .foregroundColor(.black)
                                                    .font(.caption)
                                            )
                                            .frame(width: 40, height: 40)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .background(Color.uIpurple.opacity(0.6))
                        .cornerRadius(15)
                    }
                }
                .frame(width: isExpanded ? 320 : 200, height: isExpanded ? 420 : 250)
                .background(Color.uIpurple.opacity(0.6))
                .cornerRadius(15)
                .padding(.bottom, 30)
            }
            
            HStack(spacing: 20) {
                Button(action: {
                    withAnimation {
                        currentIndex = max(currentIndex - 1, 0)
                    }
                }) {
                    Text("Back")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    withAnimation {
                        currentIndex = min(currentIndex + 1, trendingItems.count - 1)
                    }
                }) {
                    Text("Next")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color.uIpurple)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
        }
    }
}
struct RecommendedView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendedView()
    }
}
