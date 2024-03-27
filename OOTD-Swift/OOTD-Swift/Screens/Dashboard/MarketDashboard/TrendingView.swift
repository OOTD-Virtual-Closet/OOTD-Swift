
//
//  TrendingView.swift
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

struct TrendingView: View {
    @State private var currentIndex = 0
    @State private var isShowingDetails = false
    @State private var isShowingCart = false
    let trendingItems: [ClothingItemElements] = [
        ClothingItemElements(name: "Clothing 1", descrption: "Otton shirt. Classic sollar. Short sleeve. Cuts at the Bottoms. Button close on the front.", image: "clothing1", price: "$49.99", description: "A cool piece of clothing.", color: "#33673B"),
        ClothingItemElements(name: "Clothing 2",descrption: "Otton shirt. Classic sollar. Short sleeve. Cuts at the Bottoms. Button close on the front.", image: "clothing2", price: "$59.99", description: "Another cool piece of clothing.", color: "#3E8989"),
        ClothingItemElements(name: "Clothing 3",descrption: "Otton shirt. Classic sollar. Short sleeve. Cuts at the Bottoms. Button close on the front.", image: "clothing3", price: "$39.99", description: "Yet another cool piece of clothing.", color: "#D1B490")
    ]
    @State private var cartItems: [ClothingItemElements] = []
    
    var body: some View {
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
                
                Button(action: {
                    isShowingCart.toggle()
                }) {
                    Image(systemName: "cart.fill")
                }
                .sheet(isPresented: $isShowingCart) {
                    ShoppingCartView(cartItems: cartItems)
                }
                Text("Shopping Cart")
                    .foregroundColor(.black)
                    .font(.system( size: 18))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
            }
            .padding(.leading, 35)
            .padding(.bottom, 20)
            //            Spacer()
            
            Button(action: {
                isShowingDetails = true
            }) {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.uIpurple.opacity(0.6))
                    .frame(width: 210, height: 310)
                    .overlay(
                        Image(trendingItems[currentIndex].image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 180, height: 275)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    )
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
            //            .padding(.horizontal, 25)
            Spacer()
        }
        .sheet(isPresented: $isShowingDetails) {
            ClothingItemDetailsView(item: trendingItems[currentIndex], addToCart: {item in cartItems.append(item)
                print("Item added to cart: \(item.name)")
            })
        }
    }
}
struct ShoppingCartView: View {
    var cartItems: [ClothingItemElements]
    
    var body: some View {
        VStack {
            Text("Shopping Cart")
                .font(.title)
                .fontWeight(.bold)
            List(cartItems) { item in
                Text(item.name)
            }
            Spacer()
        }
    }
}

struct ClothingItemDetailsView: View {
    var item: ClothingItemElements
    var addToCart: (ClothingItemElements) -> Void
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
                    addToCart(item)
                    presentationMode.wrappedValue.dismiss()
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
struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}
