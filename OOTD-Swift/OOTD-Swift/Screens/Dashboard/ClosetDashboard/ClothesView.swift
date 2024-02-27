//
//  ClothesView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

struct ClothesView: View {
    let items = (1...10).map { "Item \($0)" }
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var showPopUp = false
    @State private var showDatePicker = false
    @State private var selectedDate = Date()


    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack (alignment: .leading) {
                Text("0 Items")
                    .foregroundColor(.gray)
                    .font(.system( size: 13))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                Text("Your Closet")
                    .foregroundColor(.black)
                    .font(.system( size: 25))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
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
                    .actionSheet(isPresented: $showPopUp) {
                        ActionSheet(title: Text("Options"), buttons: [
                            .default(Text("Date Last Worn")) {  self.showDatePicker = true  },
                            .default(Text("Type of Clothing")) { /* Handle Option 2 */ },
                            .default(Text("Color of Clothing")) { /* Handle Option 3 */ },
                            .cancel()
                        ])
                    }
                }
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
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: [GridItem(.fixed(130))], spacing: 10) {
                        ForEach(items, id: \.self) { item in
                            Clothes(item: item)
                                .frame(width: 112, height: 140)
                        }
                    }
                    .padding(10)
                }.padding(.trailing, 15)
                
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
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: [GridItem(.fixed(130))], spacing: 10) {
                        ForEach(items, id: \.self) { item in
                            Clothes(item: item)
                                .frame(width: 112, height: 140)
                        }
                    }
                    .padding(10)
                }.padding(.trailing, 15)
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
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: [GridItem(.fixed(130))], spacing: 10) {
                        ForEach(items, id: \.self) { item in
                            Clothes(item: item)
                                .frame(width: 112, height: 140)
                        }
                    }
                    .padding(10)
                }.padding(.trailing, 15)
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
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: [GridItem(.fixed(130))], spacing: 10) {
                        ForEach(items, id: \.self) { item in
                            Clothes(item: item)
                                .frame(width: 120, height: 140)
                        }
                    }
                    .padding(10)
                }.padding(.trailing, 15)

            }
            .sheet(isPresented: $showDatePicker) {
                NavigationView {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .navigationTitle("Date Last Worn")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancel") {
                                    showDatePicker = false
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    // Here, you can handle the selected date,
                                    // e.g., filtering your items based on this date.
                                    showDatePicker = false
                                }
                            }
                        }
                }
            }
            Color.white
                    .frame(width: UIScreen.main.bounds.width, height: 100)

        }
    }
}


struct Clothes: View {
    let item: String
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(hex: "E1DDED"))
                .frame(width: 112, height: 130)
                .overlay(
                    Text(item)
                        .foregroundColor(.white)
                        .font(.headline)
                )
            Text("Item Title")
                .foregroundColor(.black)
                .font(.system( size: 12))
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 5)
            Text("Last Worn")
                .foregroundColor(.gray)
                .font(.system( size: 9))
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 5)
        }
    }
}

struct ClothesView_Previews: PreviewProvider {
    static var previews: some View {
        ClothesView()
    }
}
