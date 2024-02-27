//
//  ClothesView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI
struct ClothingItem: Identifiable, Hashable {
    var id = UUID()
    var name: String // Name or description of the item
    var lastWorn: Date? // Optional last worn date
    var color: String
    var clothingType: String

    init(name: String, lastWorn: Date? = nil, color: String = "", clothingType: String = "") {
        self.name = name
        self.lastWorn = lastWorn
        self.color = color
        self.clothingType = clothingType
    }
}

struct ClothesView: View {
    @State private var items: [ClothingItem] = [
        ClothingItem(name: "Item 1", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 21)), color: "Red"),
        ClothingItem(name: "Item 2", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 22)), color: "Blue"),
        ClothingItem(name: "earmuffs", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 23)), color: "Green"),
        ClothingItem(name: "Item 4", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 24)), color: "Yellow"),
        ClothingItem(name: "Item 5", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 19)), color: "Orange"),
        ClothingItem(name: "Item 6", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 18)), color: "Tomato Red"),
        ClothingItem(name: "Item 7", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 17)), color: "Purple"),
        ClothingItem(name: "Item 8", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 16)), color: "Indigo"),
        ClothingItem(name: "Item 9", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 15)), color: "Violet"),
        ClothingItem(name: "Item 10", lastWorn: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 14)), color: "Greenish Cob"),
        
        // Add more items as needed
    ]
//    let items = (1...10).map { "Item \($0)" }
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var showPopUp = false
    
    // Classofications for the modals
    @State private var showDatePicker = false
    @State private var showClothingCategory = false
    @State private var selectedClothingCatergory = ""
    @State private var selectedDate = Date()
    @State private var clothingCategories = ["Shirts", "Pants", "Hoodies & Jackets", "Shoes", "Accessories"]



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
                            .default(Text("Type of Clothing")) { self.showClothingCategory = true },
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
//                        ForEach(items, id: \.self) { item in
//                            Clothes(item: item)
//                                .frame(width: 112, height: 140)
//                        }
                        ForEach(items) { item in
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
            .sheet(isPresented: $showClothingCategory) {
                ClothingTypeSelectionView(selectedClothingType: $selectedClothingCatergory, clothingCategories: clothingCategories)
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
                                    showDatePicker = false
                                    //Will print out the selected date correctly
                                        //Need to substring the date tho
                                    print(selectedDate)
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

struct ClothingTypeSelectionView: View {
    @Binding var selectedClothingType: String
    var clothingCategories: [String]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                ForEach(clothingCategories, id: \.self) { category in
                    Button(action: {
                        self.selectedClothingType = category
                    }) {
                        Text(category)
                    }
                }
            }
            .navigationBarTitle(Text("Select Clothing Type"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct Clothes: View {
    let item: ClothingItem
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(hex: "E1DDED"))
                .frame(width: 112, height: 130)
                .overlay(
                    Text(item.name)
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
