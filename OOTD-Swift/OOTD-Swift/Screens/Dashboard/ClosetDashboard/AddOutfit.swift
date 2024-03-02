//
//  AddOutfit.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/1/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

import UIKit



struct AddOutfit: View {
    @Environment(\.presentationMode) var presentationMode
    
    var uid = UserDefaults.standard.string(forKey: "uid") ?? "uid"


    @State var tops: [Cloth]?
    @State var jackets : [Cloth]?
    @State var bottoms : [Cloth]?
    @State var shoes : [Cloth]?
    @State private var isEditing = false
    private var genreOptions = ["Streetwear", "Formalwear", "Casual", "Business Casual", "Pajamas"]

    
    @State var selectedTop: String?
    @State var selectedJacket: String?
    @State var selectedBottom: String?
    @State var selectedShoes: String?
    @State private var searchText = ""
    @State private var selectedGenre : String?
    
    


    
    @State var showAlert = false
    @State var alertMessage = "Please fill out all fields"
    
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
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("Tops")
                                .foregroundColor(.black)
                                .font(.system( size: 20))
                                .fontWeight(.heavy)
                                .padding(.leading, 15)
                                .padding(.top, 20)
                            Spacer()
                        }
                        
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 10) {
                                ForEach(tops ?? [], id: \.self) { view in
                                    Button(action: {
                                                    selectedTop = view.id 
                                                }) {
                                                    Clothes(item: view.id)
                                                        .frame(width: 112, height: 140)
                                                }.overlay(
                                                    
                                                    selectedTop == view.id ?
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundColor(.purple)
                                                            .font(.system(size: 24))
                                                            .padding(5)
                                                            .background(Color.white)
                                                            .clipShape(Circle())
                                                            .offset(x: 50, y: -50)
                                                        : nil
                                                )
                                }
                            }.padding(10)
                        }
                        .padding(.trailing, 15)
                        HStack {
                            Text("Jackets/Hoodies")
                                .foregroundColor(.black)
                                .font(.system( size: 20))
                                .fontWeight(.heavy)
                                .padding(.leading, 15)
                                .padding(.top, 20)
                            Spacer()
                        }
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 10) {
                                ForEach(jackets ?? [], id: \.self) { view in
                                    Button(action: {
                                                    selectedJacket = view.id // Update selectedTop with the UUID of the selected top
                                                }) {
                                                    Clothes(item: view.id)
                                                        .frame(width: 112, height: 140)
                                                }.overlay(
                                                    
                                                    selectedJacket == view.id ?
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundColor(.purple)
                                                            .font(.system(size: 24))
                                                            .padding(5)
                                                            .background(Color.white)
                                                            .clipShape(Circle())
                                                            .offset(x: 50, y: -50)
                                                        : nil
                                                )
                                }
                            }.padding(10)
                        }
                        HStack {
                            Text("Bottoms")
                                .foregroundColor(.black)
                                .font(.system( size: 20))
                                .fontWeight(.heavy)
                                .padding(.leading, 15)
                                .padding(.top, 20)
                            Spacer()
                        }
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 10) {
                                ForEach(bottoms ?? [], id: \.self) { view in
                                    Button(action: {
                                                    selectedBottom = view.id // Update selectedTop with the UUID of the selected top
                                                }) {
                                                    Clothes(item: view.id)
                                                        .frame(width: 112, height: 140)
                                                } .overlay(
                                                    
                                                    selectedBottom == view.id ?
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundColor(.purple)
                                                            .font(.system(size: 24))
                                                            .padding(5)
                                                            .background(Color.white)
                                                            .clipShape(Circle())
                                                            .offset(x: 50, y: -50)
                                                        : nil
                                                )
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
                            Spacer()
                        }
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 10) {
                                ForEach(shoes ?? [], id: \.self) { view in
                                    Button(action: {
                                                    selectedShoes = view.id
                                                }) {
                                                    Clothes(item: view.id)
                                                        .frame(width: 112, height: 140)
                                                }.overlay(
                                                    
                                                    selectedShoes == view.id ?
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundColor(.purple)
                                                            .font(.system(size: 24))
                                                            .padding(5)
                                                            .background(Color.white)
                                                            .clipShape(Circle())
                                                            .offset(x: 50, y: -50)
                                                        : nil
                                                )
                                }
                            }.padding(10)
                        }
                        .padding(.trailing, 15)
                        HStack {
                            Text("Outfit Name")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .font(.system( size: 18))
                                .padding(.leading, 18)
                            Spacer()
                        }
                        
                        ZStack {
                                    TextField("", text: $searchText, onEditingChanged: { editing in
                                        isEditing = editing
                                    }).onChange(of: searchText) { newValue in
                                        if newValue.count > 20 {
                                            searchText = String(newValue.prefix(20))
                                        }
                                    }

                                    .frame(width: UIScreen.main.bounds.width - 90, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color(hex: "E1DDED"))
                                            .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                                            .shadow(radius: 4)
                                    )
                                    .overlay(
                                        HStack {
                                            Text("Name...")
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                        .opacity(isEditing || !searchText.isEmpty ? 0 : 1)
                                    )
                        }
                        .padding(.horizontal,25)
                            .padding(.vertical, 10)
                        CustomDropDown(title: "Genre", prompt: "Select a Genre", options: genreOptions, selection: $selectedGenre)
                    }
                Rectangle()
                    .foregroundColor(Color.white)
                    .frame(height: UIScreen.main.bounds.height / 5)
                    .ignoresSafeArea(.all)
                    
            }.padding(.top, 100)
            
            
            Rectangle()
                .foregroundColor(Color(hex: "9278E0"))
                .frame(height: UIScreen.main.bounds.height / 8)
                .ignoresSafeArea(.all)
            HStack {
                Button(action: {
                    
                    
                    if selectedTop == nil || selectedJacket == nil || selectedBottom == nil || selectedShoes == nil || searchText == "" || selectedGenre == nil  {
                        showAlert = true
                    }
                     else {
                         let outfit = Outfit(name: searchText, genre: selectedGenre ?? "", cloth1: selectedTop ?? "", cloth2: selectedJacket ?? "", cloth3: selectedBottom ?? "", cloth4: selectedShoes ?? "")
                         
                         let outfitViewModel = OutfitViewModel()
                         
                         outfitViewModel.addOutfitToCurrentUser(outfit: outfit)
                         presentationMode.wrappedValue.dismiss()
                     }
                    
                }) {
                    Text("Add")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.leading, 15)
                        .font(.system(size: 12))
                }
                Spacer()
                Text("New Outfit")
                    .foregroundColor(.white)
                    .font(.system( size: 20))
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Cancel")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding(.trailing, 15)
                                    .font(.system( size: 12))
                            }
            }.padding(.top, 20)
            
        }
        .onAppear {
            populateArrays {
                print("arrays populated for add outfit")
            }
        }
        .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
       
  }
}



struct AddOutfitsView: PreviewProvider {
    static var previews: some View {
        AddClothes()
    }
}
