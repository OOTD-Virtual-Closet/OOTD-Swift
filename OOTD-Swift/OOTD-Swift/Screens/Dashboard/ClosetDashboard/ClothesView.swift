//
//  ClothesView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
//struct ClothingItem: Identifiable, Hashable {
  //  var id = UUID()
   // var name: String // Name or description of the item
   // var lastWorn: Date? // Optional last worn date
   // var color: String
   // var clothingType: String
    
    //init(name: String, lastWorn: Date? = nil, color: String = "", clothingType: String = "") {
     //   self.name = name
     //   self.lastWorn = lastWorn
     //   self.color = color
     //   self.clothingType = clothingType
   // }
//}

struct ClothesView: View {
    
    var uid = UserDefaults.standard.string(forKey: "uid") ?? "uid"

    @State private var tops : [Cloth]?
    @State private var bottoms : [Cloth]?
    @State private var jackets : [Cloth]?
    @State private var shoes : [Cloth]?
    
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
    @State private var showColorPicker = false
    @State private var selectedColor: String = ""
    @State private var addClothesPresented = false
    
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
                        tops = loadedCloths.filter { $0.type == "Tops" }
                        bottoms = loadedCloths.filter { $0.type == "Bottoms" }
                        jackets = loadedCloths.filter { $0.type == "Jackets/Hoodies" }
                        shoes = loadedCloths.filter { $0.type == "Shoes" }
                        
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
                                    .default(Text("Color of Clothing")) {
                                    self.showColorPicker = true
                                    },
                                    .cancel()
                                ])
                            }
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
                                ForEach(tops ?? [], id: \.self) { view in
                                    Clothes(item: view.id)
                                        .frame(width: 112, height: 140)
                                }
                            }.padding(10)
                        }
                        .padding(.trailing, 15)
                        
                        
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
                                ForEach(jackets ?? [], id: \.self) { view in
                                    Clothes(item: view.id)
                                        .frame(width: 112, height: 140)
                                }
                            }.padding(10)
                        }.padding(.trailing, 15)
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
                                ForEach(bottoms ?? [], id: \.self) { view in
                                    Clothes(item: view.id)
                                        .frame(width: 112, height: 140)
                                }
                            }.padding(10)
                        }
                        .padding(.trailing, 15)
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
//                        ScrollView(.horizontal) {
                        LazyHStack(spacing: 10) {
                            ForEach(shoes ?? [], id: \.self) { view in
                                Clothes(item: view.id)
                                    .frame(width: 112, height: 140)
                            }
                        }.padding(10)
                    }
                    .padding(.trailing, 15)
                    .sheet(isPresented: $showColorPicker) {
                        ColorSelectionView(selectedColor: $selectedColor)
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

struct Clothes: View {
    let item: String // UUID of the cloth document
    
    @State var cloth: Cloth? // Cloth object fetched from Fire
    
    @StateObject var imageLoader = ImageLoader() // Image load
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(hex: "E1DDED"))
                .frame(width: 112, height: 130)
                .overlay(
                        Group {
                                                if let image = imageLoader.image {
                                                    Image(uiImage: image)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                } else {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .foregroundColor(Color(hex: "E1DDED"))
                                                        .frame(width: 112, height: 130)
                                                }
                                            }
                )
            Text(cloth?.name ?? "Name")
                .foregroundColor(.black)
                .font(.system(size: 12))
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 5)
            Text("Last Worn 2/30/2024")
                .foregroundColor(.gray)
                .font(.system(size: 9))
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 5)
        }
        .onAppear {
            fetchClothFromFirestore {
                print("fetched cloth and stuff")
            }
        }
    }

    
    
    private func fetchClothFromFirestore(completion: @escaping () -> Void) {
        let docRef = Firestore.firestore().collection("clothes").document(item)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                do {
                    cloth = try document.data(as: Cloth.self)
                    print("Cloth successfully fetched")
                    
                    if let imageUrl = cloth?.image {
                        let storageRef = Storage.storage().reference()
                        storageRef.child(imageUrl).downloadURL { url, error in
                            if let url = url {
                                // Load image using image loader
                                imageLoader.loadImage(from: url)
                            } else if let error = error {
                                print("Error downloading image: \(error.localizedDescription)")
                            }
                            completion() // Call completion handler after fetching image
                        }
                    } else {
                        completion() // Call completion handler if image URL is nil
                    }
                } catch {
                    print("Error decoding cloth document: \(error.localizedDescription)")
                    completion() // Call completion handler if error occurs during decoding
                }
            } else {
                print("Cloth document does not exist")
                completion() // Call completion handler if document does not exist
            }
        }
    }
}
struct ClothesView_Previews: PreviewProvider {
    static var previews: some View {
        Clothes(item: "17211A52-1FB4-4423-9649-9C300F45D91E")
    }
}
