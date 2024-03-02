//
//  FavoriteClothes.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/25/24.
//

import Foundation
import SwiftUI

struct FavoriteClothes: View {
    //@State private var items: [ClothingItem] = [
    //    ClothingItem(name: "Item 1", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 21)), color: "Red"),
     //   ClothingItem(name: "Item 2", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 22)), color: "Blue"),
     //   ClothingItem(name: "Item 3", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 23)), color: "Green"),
      //  ClothingItem(name: "Item 4", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 24)), color: "Yellow"),
      //  ClothingItem(name: "Item 5", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 19)), color: "Orange"),
      //  ClothingItem(name: "Item 6", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 18)), color: "Tomato Red"),
      //  ClothingItem(name: "Item 7", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 17)), color: "Purple"),
      //  ClothingItem(name: "Item 8", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 16)), color: "Indigo"),
      //  ClothingItem(name: "Item 9", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 15)), color: "Violet"),
       // ClothingItem(name: "Item 10", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 14)), color: "Greenish Cob"),
        
        // Add more items as needed
    //]

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
                // ScrollView(.horizontal, showsIndicators: true) {
                //    LazyHGrid(rows: [GridItem(.fixed(130))], spacing: 10) {
                //    ForEach(items, id: \.self) { item in
                //     TestClothes(item: item)
                //        .frame(width: 120, height: 140)
                //    }
                //  }
                //   .padding(10)
                // }.padding(.trailing, 15)
                
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
                //ScrollView(.horizontal, showsIndicators: true) {
                //  LazyHGrid(rows: [GridItem(.fixed(130))], spacing: 10) {
                //  ForEach(items, id: \.self) { item in
                //   TestClothes(item: item)
                //  .frame(width: 112, height: 140)
                //  }
                // }
                // .padding(10)
                // }.padding(.trailing, 15)
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
                // ScrollView(.horizontal, showsIndicators: true) {
                //   LazyHGrid(rows: [GridItem(.fixed(130))], spacing: 10) {
                //   ForEach(items, id: \.self) { item in
                //     TestClothes(item: item)
                //      .frame(width: 112, height: 140)
                //  }
                //   }
                //  .padding(10)
                // }.padding(.trailing, 15)
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
                //  ScrollView(.horizontal, showsIndicators: true) {
                //     LazyHGrid(rows: [GridItem(.fixed(130))], spacing: 10) {
                //    ForEach(items, id: \.self) { item in
                //    TestClothes(item: item)
                //        .frame(width: 120, height: 140)
                //    }
                //  }
                //.padding(10)
                //  }.padding(.trailing, 15)
                
                Color.white
                    .frame(width: UIScreen.main.bounds.width, height: 100)
                
            }
        }
        .padding(.top, 40)
        .ignoresSafeArea(.all)
    }
        
    
}




