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
    var descrption: String
    var image: String
    var price: String
    var description: String
    var color: String
}

struct RecommendedView: View {
    let trendingItems: [ClothingItemElements] = [
        ClothingItemElements(name: "Clothing 1", descrption: "Otton shirt. Classic sollar. Short sleeve. Cuts at the Bottoms. Button close on the front.", image: "clothing1", price: "$49.99", description: "A cool piece of clothing.", color: "#33673B"),
        ClothingItemElements(name: "Clothing 2",descrption: "Otton shirt. Classic sollar. Short sleeve. Cuts at the Bottoms. Button close on the front.", image: "clothing2", price: "$59.99", description: "Another cool piece of clothing.", color: "#3E8989"),
        ClothingItemElements(name: "Clothing 3",descrption: "Otton shirt. Classic sollar. Short sleeve. Cuts at the Bottoms. Button close on the front.", image: "clothing3", price: "$39.99", description: "Yet another cool piece of clothing.", color: "#D1B490")
    ]
    var body: some View {
        ScrollView {
            VStack {
                Text("36 items")
                    .foregroundColor(.gray)
                    .font(.system( size: 13))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.leading, 10)
                    .padding(.top, 10)
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
                                    .foregroundColor(.black)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 30)
                                    .background(Color(hex:"489FB5"))
                                    .cornerRadius(15)
                            }
                            .padding(.bottom, 10)
                            
                            ImageCardView(item: trendingItems[2])
                            
                            Button(action: {
                                print("Like button tapped")
                            }) {
                                Text("Like")
                                    .foregroundColor(.black)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 30)
                                    .background(Color(hex:"CBC3E3"))
                                    .cornerRadius(15)
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
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 300)
            
            HStack {
                Text(item.name)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .padding()
                Text(item.price)
                    .fontWeight(.heavy)
                Spacer()
            }
            .padding(.leading, 20)
            
            HStack {
                Text(item.descrption)
                    .fontWeight(.medium)
                    .padding(.leading, 10)
                Spacer()
            }
            .padding(.leading, 20)
            HStack {
                Text("Color")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .padding()
                Spacer()
            }
            .padding(.leading, 20)
            HStack {
                Circle()
                    .fill(Color(hex: item.color))
                    .frame(width: 24, height: 24)
                Spacer()
            }
            .padding(.leading, 40)
            HStack {
                Text("Size")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .padding()
                Spacer()
            }
            .padding(.leading, 20)
            HStack {
                Circle()
                    .foregroundColor(Color(hex:"F6F6F6"))
                    .overlay(
                        Text("XS")
                            .foregroundColor(.black)
                            .font(.caption)
                    )
                    .frame(width: 40, height: 40)
                Circle()
                    .foregroundColor(Color(hex:"F6F6F6"))
                    .overlay(
                        Text("S")
                            .foregroundColor(.black)
                            .font(.caption)
                    )
                    .frame(width: 40, height: 40)
                Circle()
                    .foregroundColor(Color(hex:"F6F6F6"))
                    .overlay(
                        Text("M")
                            .foregroundColor(.black)
                            .font(.caption)
                    )
                    .frame(width: 40, height: 40)
                Circle()
                    .foregroundColor(Color(hex:"F6F6F6"))
                    .overlay(
                        Text("L")
                            .foregroundColor(.black)
                            .font(.caption)
                    )
                    .frame(width: 40, height: 40)
                Circle()
                    .foregroundColor(Color(hex:"F6F6F6"))
                    .overlay(
                        Text("XL")
                            .foregroundColor(.black)
                            .font(.caption)
                    )
                    .frame(width: 40, height: 40)
                Spacer()
            }
            .padding(.leading, 40)
            HStack {
                Button(action: {
                    print("Cancel")
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .background(Color(hex:"EF5B5B"))
                        .cornerRadius(15)
                }
                .padding(.top, 10)
                .padding(.leading, 10)
                Button(action: {
                    print("Add to Cart")
                }) {
                    Text("Add to Cart")
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .background(Color(hex:"FFBA49"))
                        .cornerRadius(15)
                }
                .padding(.top, 10)
                .padding(.leading, 10)
            }
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
