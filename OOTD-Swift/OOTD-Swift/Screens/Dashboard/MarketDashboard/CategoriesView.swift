//
//  CategoriesView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

struct CategoriesView: View {
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var showPopUp = false
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView (showsIndicators: false) {
            VStack (alignment: .leading) {
                Text("36 items")
                    .foregroundColor(.gray)
                    .font(.system( size: 13))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .padding(.top, 10)
                    .padding(.leading, 10)
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
                HStack {
                    ZStack {
                        TextField("", text: $searchText, onEditingChanged: { editing in
                            isEditing = editing
                        })
                        .padding(.leading, 15)
                        .frame(width: UIScreen.main.bounds.width - 90, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(hex: "E1DDED"))
                                .padding(.leading, 15)
                        )
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .foregroundColor(.black)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .padding(.leading, 27)
                                Text("Search...")
                                    .foregroundColor(.black)
                                    .font(.system(size: 17))
                                    .fontWeight(.heavy)
                                    .padding(.leading, 5)
                                Spacer()
                            }
                                .opacity(isEditing || !searchText.isEmpty ? 0 : 1)
                        )
                    }
                    Spacer()
                    ZStack {
                        Button(action: {
                            self.showPopUp.toggle()
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .resizable()
                                .foregroundColor(.black)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .padding(.trailing, 20)
                        }
                    }
                }
                Spacer()
                LazyVGrid(columns: gridItems, spacing: 20) {
                    ForEach(0..<4) { _ in
                        Image("shoes")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        Image("hoodie")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        Image("scarf")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        Image("jacket")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 20)
            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
