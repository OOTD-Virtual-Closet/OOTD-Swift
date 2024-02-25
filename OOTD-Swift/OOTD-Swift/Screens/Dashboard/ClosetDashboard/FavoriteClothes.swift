//
//  FavoriteClothes.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/25/24.
//

import Foundation
import SwiftUI

struct FavoriteClothes: View {
    let items = (1...10).map { "Item \($0)" }

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Shirts")
                        .foregroundColor(.black)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.leading, 15)
                        .padding(.top, 20)
                    Text("(1)")
                        .foregroundColor(.gray)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.top, 20)
                }
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: [GridItem(.fixed(130))], spacing: 10) {
                        ForEach(items, id: \.self) { item in
                            Clothes(item: item)
                                .frame(width: 112, height: 140)
                        }
                    }
                    .padding(10)
                }.padding(.horizontal, 15)
                
                HStack {
                    Text("Hoodies & Jackets")
                        .foregroundColor(.black)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.leading, 15)
                        .padding(.top, 20)
                    Text("(1)")
                        .foregroundColor(.gray)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.top, 20)
                }
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: [GridItem(.fixed(130))], spacing: 10) {
                        ForEach(items, id: \.self) { item in
                            Clothes(item: item)
                                .frame(width: 112, height: 140)
                        }
                    }
                    .padding(10)
                }.padding(.horizontal, 15)
                HStack {
                    Text("Pants")
                        .foregroundColor(.black)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.leading, 15)
                        .padding(.top, 20)
                    Text("(5)")
                        .foregroundColor(.gray)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.top, 20)
                }
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: [GridItem(.fixed(130))], spacing: 10) {
                        ForEach(items, id: \.self) { item in
                            Clothes(item: item)
                                .frame(width: 112, height: 140)
                        }
                    }
                    .padding(10)
                }.padding(.horizontal, 15)
                HStack {
                    Text("Shoes")
                        .foregroundColor(.black)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.leading, 15)
                        .padding(.top, 20)
                    Text("(2)")
                        .foregroundColor(.gray)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.top, 20)
                }
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: [GridItem(.fixed(130))], spacing: 10) {
                        ForEach(items, id: \.self) { item in
                            Clothes(item: item)
                                .frame(width: 120, height: 140)
                        }
                    }
                    .padding(10)
                }.padding(.horizontal, 15)

            }
        }
        .padding(.top, 40)
        .ignoresSafeArea(.all)

        
    }
}




