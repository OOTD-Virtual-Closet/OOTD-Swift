//
//  OutfitsView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

struct OutfitsView: View {
    let items = (1...10).map { "Item \($0)" }
    @State private var searchText = ""
    @State private var isEditing = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("0 Items")
                    .foregroundColor(.gray)
                    .font(.system( size: 13))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                Text("Your Outfits")
                    .foregroundColor(.black)
                    .font(.system( size: 25))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                TextField("", text: $searchText, onEditingChanged: { editing in
                    isEditing = editing
                })
                .padding(.leading, 30)
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
                ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
                                ForEach(items, id: \.self) { item in
                                    Outfits(item: item)
                                }
                            }
                            .padding(15)
                        }

            }
        }
    }
}
struct Outfits: View {
    let item: String
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(hex: "E1DDED"))
                .frame(width: 170, height: 250)
                .overlay(
                    Text(item)
                        .foregroundColor(.white)
                        .font(.headline)
                )
            Text("Item Title")
                .foregroundColor(.black)
                .font(.system( size: 15))
                .fontWeight(.heavy)
                .padding(.leading, 5)
            Text("Last Worn")
                .foregroundColor(.gray)
                .font(.system( size: 10))
                .fontWeight(.heavy)
                .padding(.leading, 5)
        }
    }
}

struct OutfitsView_Previews: PreviewProvider {
    static var previews: some View {
        OutfitsView()
    }
}
