//
//  ClothesView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage


struct ClothesView: View {
    
    var uid = UserDefaults.standard.string(forKey: "uid") ?? "uid"

    @State private var tops : [Cloth]?
    @State private var bottoms : [Cloth]?
    @State private var jackets : [Cloth]?
    @State private var shoes : [Cloth]?
    
    @State private var filteredTops: [Cloth] = []
    @State private var filteredBottoms: [Cloth] = []
    @State private var filteredJackets: [Cloth] = []
    @State private var filteredShoes: [Cloth] = []
    let tags: [String] = ["All", "casual", "sport"]
    @State private var selectedTag: String = "All"
    
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var showPopUp = false
    
    // Classofications for the modals
    @State private var showDatePicker = false
    @State private var showClothingCategory = false
    @State private var selectedClothingCatergory = ""
    @State private var selectedDate = Date()
    @State private var clothingCategories = ["Shirts", "Pants", "Hoodies & Jackets", "Shoes", "Accessories"]
    @State private var showColorPicker = false
    @State private var selectedColor: String = ""
    @State private var addClothesPresented = false
    
    @State private var expandedClothesPresented = false;
    @State private var expandedClothesChosen : Cloth?
    
    private func filterByTag(clothes: [Cloth]?) -> [Cloth] {
        guard selectedTag != "All" else {return clothes ?? [] }
        return clothes!.filter { $0.tags?.contains(selectedTag) ?? false }
    }
    
    private func filterClothes(searchText: String, clothes: [Cloth]?) -> [Cloth] {
        guard !searchText.isEmpty else { return clothes ?? [] }
        return clothes?.filter { $0.name!.localizedCaseInsensitiveContains(searchText) } ?? []
    }
    
    private func populateAndFilter() {
        populateArrays {
            filteredTops = filterClothes(searchText: searchText, clothes: tops)
            filteredBottoms = filterClothes(searchText: searchText, clothes: bottoms)
            filteredJackets = filterClothes(searchText: searchText, clothes: jackets)
            filteredShoes = filterClothes(searchText: searchText, clothes: shoes)
        }
    }
    
    private func populateArrays(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let clothes = document.data()?["clothes"] as? [String] {
                    var loadedCloths = [Cloth]()
                    let dispatchGroup = DispatchGroup()
                    
                    for item in clothes {
                        dispatchGroup.enter()
                        
                        let docRef = db.collection("clothes").document(item)
                        docRef.getDocument { document, error in
                            defer {
                                dispatchGroup.leave()
                            }
                            if let document = document, document.exists {
                                do {
                                    let cloth =  try document.data(as: Cloth.self)
                                        loadedCloths.append(cloth)
                                    
                                } catch {
                                    print("Error decoding cloth document: \(error.localizedDescription)")
                                }
                            } else {
                                print("Cloth document does not exist")
                            }
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        let loadedTops = loadedCloths.filter { $0.type == "Tops" }
                        let loadedBottoms = loadedCloths.filter { $0.type == "Bottoms" }
                        let loadedJackets = loadedCloths.filter { $0.type == "Jackets/Hoodies" }
                        let loadedShoes = loadedCloths.filter { $0.type == "Shoes" }
                        
                        tops = filterByTag(clothes: loadedTops)
                        bottoms = filterByTag(clothes: loadedBottoms)
                        jackets = filterByTag(clothes: loadedJackets)
                        shoes = filterByTag(clothes: loadedShoes)
                        
                        completion()
                    }
                }
            } else {
                print("User document does not exist")
            }
        }
    }



    var body: some View {
        ZStack (alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                var totalItemCount: Int {
                    let topsCount = tops?.count ?? 0
                    let bottomsCount = bottoms?.count ?? 0
                    let jacketsCount = jackets?.count ?? 0
                    let shoesCount = shoes?.count ?? 0
                    return topsCount + bottomsCount + jacketsCount + shoesCount
                }
                    VStack (alignment: .leading) {
                        Text("\(totalItemCount) Items")
                            .foregroundColor(.gray)
                            .font(.system( size: 13))
                            .fontWeight(.heavy)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                            .padding(.top, 5)
                        Text("Your Closet")
                            .foregroundColor(.black)
                            .font(.system( size: 25))
                            .fontWeight(.heavy)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                        HStack {
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
                            Spacer()
                            Menu {
                                Picker(selection: $selectedTag, label: Text("Filter by Tag")) {
                                    ForEach(tags, id: \.self) { tag in
                                        Text(tag).tag(tag)
                                    }
                                }
                            } label: {
                                Label("", systemImage: "slider.horizontal.3")
                                    .foregroundColor(.black)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                            }
                            .onChange(of: selectedTag) { _ in
                                filteredTops = filterByTag(clothes: tops)
                                filteredBottoms = filterByTag(clothes: bottoms)
                                filteredJackets = filterByTag(clothes: jackets)
                                filteredShoes = filterByTag(clothes: shoes)
                            }
                            .padding(.trailing, 20)
//                            ZStack {
//                                Button(action: {
//                                    self.showPopUp.toggle()
//                                }) {
//                                    Image(systemName: "slider.horizontal.3")
//                                        .resizable()
//                                        .foregroundColor(.black)
//                                        .aspectRatio(contentMode: .fit)
//                                        .frame(width: 30, height: 30)
//                                        .padding(.trailing, 20)
//                                }
//                            }
//                            .actionSheet(isPresented: $showPopUp) {
//                                ActionSheet(title: Text("Options"), buttons: [
//                                    .default(Text("Date Last Worn")) {  self.showDatePicker = true  },
//                                    .default(Text("Type of Clothing")) { self.showClothingCategory = true },
//                                    .default(Text("Color of Clothing")) {
//                                    self.showColorPicker = true
//                                    },
//                                    .cancel()
//                                ])
//                            }
                        }
                        HStack {
                            Text("Tops")
                                .foregroundColor(.black)
                                .font(.system( size: 20))
                                .fontWeight(.heavy)
                                .padding(.leading, 15)
                                .padding(.top, 20)
                            Text("\(tops?.count ?? 0)")
                                .foregroundColor(.gray)
                                .font(.system( size: 20))
                                .fontWeight(.heavy)
                                .padding(.top, 20)
                            Spacer()
                        }
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 10) {
                                ForEach(filteredTops, id: \.self) { view in
                                    Button(action: {
                                        expandedClothesPresented.toggle()
                                        expandedClothesChosen = view
                                 
                                    }) {
                                        Clothes(item: view.id)
                                            .frame(width: 112, height: 140)
                                            
                                    }
                                }
                            }.padding(10)
                        }
                        .padding(.trailing, 15)
                        .onAppear {
                            populateAndFilter()
                        }
                        .onChange(of: searchText) { newValue in
                            filteredTops = filterClothes(searchText: newValue, clothes: tops)
                            filteredBottoms = filterClothes(searchText: newValue, clothes: bottoms)
                            filteredJackets = filterClothes(searchText: newValue, clothes: jackets)
                            filteredShoes = filterClothes(searchText: newValue, clothes: shoes)
                        }
                        
                        HStack {
                            Text("Hoodies & Jackets")
                                .foregroundColor(.black)
                                .font(.system( size: 20))
                                .fontWeight(.heavy)
                                .padding(.leading, 15)
                                .padding(.top, 20)
                            Text("\(jackets?.count ?? 0)")
                                .foregroundColor(.gray)
                                .font(.system( size: 20))
                                .fontWeight(.heavy)
                                .padding(.top, 20)
                            Spacer()
                        }
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 10) {
                                ForEach(filteredJackets, id: \.self) { view in
                                    Button(action: {
                                        expandedClothesPresented.toggle()
                                        expandedClothesChosen = view

                                    }) {
                                        
                                        Clothes(item: view.id)
                                            .frame(width: 112, height: 140)
                                            
                                    }
                                }
                            }.padding(10)
                        }
                        .padding(.trailing, 15)
                        .onAppear {
                            populateAndFilter()
                        }
                        .onChange(of: searchText) { newValue in
                            filteredTops = filterClothes(searchText: newValue, clothes: tops)
                            filteredBottoms = filterClothes(searchText: newValue, clothes: bottoms)
                            filteredJackets = filterClothes(searchText: newValue, clothes: jackets)
                            filteredShoes = filterClothes(searchText: newValue, clothes: shoes)
                        }
                        
                        HStack {
                            Text("Pants")
                                .foregroundColor(.black)
                                .font(.system( size: 20))
                                .fontWeight(.heavy)
                                .padding(.leading, 15)
                                .padding(.top, 20)
                            Text("\(bottoms?.count ?? 0)")
                                .foregroundColor(.gray)
                                .font(.system( size: 20))
                                .fontWeight(.heavy)
                                .padding(.top, 20)
                            Spacer()
                        }
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 10) {
                                ForEach(filteredBottoms, id: \.self) { view in
                                    Button(action: {
                                        expandedClothesPresented.toggle()
                                        expandedClothesChosen = view

                                    }) {
                                        
                                        Clothes(item: view.id)
                                            .frame(width: 112, height: 140)
                                            
                                    }
                                }
                            }.padding(10)
                        }
                        .padding(.trailing, 15)
                        .onAppear {
                            populateAndFilter()
                        }
                        .onChange(of: searchText) { newValue in
                            filteredTops = filterClothes(searchText: newValue, clothes: tops)
                            filteredBottoms = filterClothes(searchText: newValue, clothes: bottoms)
                            filteredJackets = filterClothes(searchText: newValue, clothes: jackets)
                            filteredShoes = filterClothes(searchText: newValue, clothes: shoes)
                        }
                        
                        HStack {
                            Text("Shoes")
                                .foregroundColor(.black)
                                .font(.system( size: 20))
                                .fontWeight(.heavy)
                                .padding(.leading, 15)
                                .padding(.top, 20)
                            Text("\(shoes?.count ?? 0)")
                                .foregroundColor(.gray)
                                .font(.system( size: 20))
                                .fontWeight(.heavy)
                                .padding(.top, 20)
                            Spacer()
                        }
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 10) {
                                ForEach(filteredShoes, id: \.self) { view in
                                    Button(action: {
                                        expandedClothesPresented.toggle()
                                        expandedClothesChosen = view
                                        
                                    }) {
                                        
                                        Clothes(item: view.id)
                                            .frame(width: 112, height: 140)
                                    }
                                }
                            }.padding(10)
                        }
                    }
                    .padding(.trailing, 15)
                    .onAppear {
                        populateAndFilter()
                    }
                    .onChange(of: searchText) { newValue in
                        filteredTops = filterClothes(searchText: newValue, clothes: tops)
                        filteredBottoms = filterClothes(searchText: newValue, clothes: bottoms)
                        filteredJackets = filterClothes(searchText: newValue, clothes: jackets)
                        filteredShoes = filterClothes(searchText: newValue, clothes: shoes)
                    }
                
//                    .sheet(isPresented: $showColorPicker) {
//                        ColorSelectionView(selectedColor: $selectedColor)
//                    }
//                    .sheet(isPresented: $showClothingCategory) {
//                        ClothingTypeSelectionView(selectedClothingType: $selectedClothingCatergory, clothingCategories: clothingCategories)
//                    }
//                    .sheet(isPresented: $showDatePicker) {
//                        NavigationView {
//                            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
//                                .datePickerStyle(GraphicalDatePickerStyle())
//                                .padding()
//                                .navigationTitle("Date Last Worn")
//                                .toolbar {
//                                    ToolbarItem(placement: .navigationBarLeading) {
//                                        Button("Cancel") {
//                                            showDatePicker = false
//                                        }
//                                    }
//                                    ToolbarItem(placement: .navigationBarTrailing) {
//                                        Button("Done") {
//                                            showDatePicker = false
//                                            //Will print out the selected date correctly
//                                                //Need to substring the date tho
//                                            print(selectedDate)
//                                        }
//                                    }
//                                }
//                        }
//                    }
                    Color.white
                            .frame(width: UIScreen.main.bounds.width, height: 100)
                   
                    
                
                

            }

            Button(action: {
                           addClothesPresented.toggle()
                       }) {
                           HStack {
                               Spacer()
                               Image(systemName: "plus")
                                   .font(.title)
                                   .foregroundColor(.black)
                                   .frame(width: 50, height: 50)
                                   .background(Color(hex: "E1DDED"))
                                   .clipShape(Circle())
                                   .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: 2)
                                                       )
                                   .padding(.trailing, 20)
                           }
                          
                               
                       }
                       .padding(.bottom, 50)
                       .sheet(isPresented: $expandedClothesPresented, onDismiss: {
                           populateArrays {
                               print("Arrays are updated again")
                           }
                       }) {
                
                           if let expandedClothesChosen = expandedClothesChosen {
                               ExpandedClothesView(mainClothe: expandedClothesChosen)
                           }
                       }
                       .sheet(isPresented: $addClothesPresented,onDismiss: {
                           populateArrays {
                               print("Arrays are updated")
                           }
                       }) {
                           AddClothes()
                       }
            
        }.onAppear {
            populateArrays {
                    print("Arrays are updated")
                }
        }
    }
}
struct ColorSelectionView: View {
    @Binding var selectedColor: String
    let colors = ["Red", "Blue", "Green", "Yellow", "Orange", "Purple", "Indigo", "Violet", "Tomato Red", "Greenish Cob"]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                ForEach(colors, id: \.self) { color in
                    Button(color) {
                        selectedColor = color
                        print(selectedColor)
                        dismiss()
                    }
                }
            }
            .navigationBarTitle(Text("Select Color"), displayMode: .inline)
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
                        print(selectedClothingType)
                        dismiss()
                    }) {
                        Text(category)
                    }
                }
            }
            .navigationBarTitle(Text("Select Clothing Type"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        print(selectedClothingType)
                        dismiss()
                    }
                }
            }
        }
    }
}

//struct TestClothes: View {
   // let item: ClothingItem
    
   // var body: some View {
   //     VStack {
     //       RoundedRectangle(cornerRadius: 10)
    //            .foregroundColor(Color(hex: "E1DDED"))
       //         .frame(width: 112, height: 130)
        //        .overlay(
         //           Text(item.name)
          //              .foregroundColor(.white)
           //             .font(.headline)
           //     )
         //   Text("Item Title")
           //     .foregroundColor(.black)
           //     .font(.system( size: 12))
           //     .fontWeight(.heavy)
           //     .frame(maxWidth: .infinity, alignment: .leading)
           //     .padding(.leading, 5)
          //  Text("Last Worn")
           //     .foregroundColor(.gray)
           //     .font(.system( size: 9))
           //     .fontWeight(.heavy)
             //   .frame(maxWidth: .infinity, alignment: .leading)
             //   .padding(.leading, 5)
        //}
   // }
//}


struct ClothesView_Previews: PreviewProvider {
    static var previews: some View {
        Clothes(item: "17211A52-1FB4-4423-9649-9C300F45D91E")
    }
}
