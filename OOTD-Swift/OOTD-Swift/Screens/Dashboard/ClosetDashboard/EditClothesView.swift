//
//  EditClothesView.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/26/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

import UIKit

struct EditClothesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var mainClothe : Cloth
    @StateObject var imageLoader = ImageLoader()
    func fetchClothFromFirestore(completion: @escaping () -> Void) {
        let docRef = Firestore.firestore().collection("clothes").document(mainClothe.id)
       docRef.getDocument { document, error in
           if let document = document, document.exists {
               do {
                   mainClothe = try document.data(as: Cloth.self)
                   print("Cloth successfully fetched")
                   
                   if let imageUrl = mainClothe.image {
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
     var sizeOptions = ["XS", "S", "M", "L", "XL", "XXL"]
     var typeOptions = ["Tops", "Bottoms", "Jackets/Hoodies", "Shoes"]
     var colorOptions = ["Red", "Blue", "Green", "Yellow", "Orange", "Purple", "Indigo", "Violet", "Tomato Red", "Greenish Cob"]
    @State  var isEditing = false
    @State  var isEditing2 = false


    @State  var name : String?
  //  @State var selectedImage: UIImage?
    @State  var selectedType : String?
    @State  var selectedSize : String?
    @State  var selectedColor : String?
    @State  var searchText = ""
    
    @State private var searchText2 = ""
    
    @State var showAlert = false
    var body: some View {
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false){
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(height: 100)
                    VStack  {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(hex: "E1DDED"))
                            .frame(width: 220, height: 300)
                            .padding(.leading, 20)
                            .padding(.top, 50)
                           .overlay(
                            Group {
                                if let image = imageLoader.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .offset(x: 10, y: 20)
                                        .frame(width: 200, height: 280)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } else {
                                    Text("Loading...")
                                }
                                }
                           )
                            
                            VStack (alignment: .leading, spacing: 10){
                                Text("Item Name")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .font(.system( size: 18))
                                    .padding(.leading, 5)
                                ZStack {
                                    TextField(mainClothe.name ?? "", text: $searchText, onEditingChanged: { editing in
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
                                                    Text(mainClothe.name ?? "")
                                                        .foregroundColor(.black)
                                                    Spacer()
                                                }
                                                .opacity(isEditing || !searchText.isEmpty ? 0 : 1)
                                            )
                                }
                                .padding(.horizontal,25)
                                    .padding(.vertical, 10)
                                
                                CustomDropDown(title: "Size", prompt: "Choose your size...", options: sizeOptions, selection: $selectedSize)
                                Text("Brand")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .font(.system( size: 18))
                                    .padding(.leading, 5)
                                ZStack {
                                    TextField(mainClothe.brand ?? "", text: $searchText2, onEditingChanged: { editing in
                                                isEditing2 = editing
                                            })
                                            .onChange(of: searchText2) { newValue in
                                                    if newValue.count > 20 {
                                                        searchText2 = String(newValue.prefix(20))
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
                                                    Text(mainClothe.brand ?? "")
                                                        .foregroundColor(.black)
                                                    Spacer()
                                                }
                                                .opacity(isEditing2 || !searchText2.isEmpty ? 0 : 1)
                                            )
                                }.padding(.horizontal,25)
                                    .padding(.vertical, 10)
                                
                                CustomDropDown(title: "Type", prompt: "Choose your type", options: typeOptions, selection: $selectedType)
                                CustomDropDown(title: "Color", prompt: "Color of Clothing", options: colorOptions, selection: $selectedColor)
                                
                                Rectangle()
                                    .foregroundColor(Color.white)
                                    .frame(height: 200)
                                    .ignoresSafeArea(.all)
                            }
                            .padding(.horizontal)
                    }
                    Button(action: {
                        if searchText == "" || searchText2 == "" || selectedType == nil || selectedColor == nil || selectedSize == nil {
                            showAlert = true
                        }
                        showAlert = false
                        let cloth = Cloth(id: mainClothe.id, name: searchText, type: selectedType, size: selectedSize, color: selectedColor, brand: searchText2, image: mainClothe.image, tags: ["casual", "sport"])
                        let clothViewModel = ClothViewModel()
                        clothViewModel.editCloth(cloth: cloth)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "square.and.arrow.down")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            Text("Save Changes")
                                .foregroundColor(.white)
                        }
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                        .background(Color(hex: "9278E0"))
                        .cornerRadius(10)
                    }
                }
                Rectangle()
                    .foregroundColor(Color(hex: "9278E0"))
                    .frame(height: UIScreen.main.bounds.height / 8)
                    .ignoresSafeArea(.all)
                HStack {
                   
                    Spacer()
                    Text("Edit Clothes")
                        .foregroundColor(.white)
                        .font(.system( size: 20))
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.top, 20)
                
            }
            .onAppear {
                fetchClothFromFirestore {
                    print("Fetched Clothes: EditClothesView")
                    selectedSize = mainClothe.size ?? ""
                    selectedType = mainClothe.type ?? ""
                    selectedColor = mainClothe.color ?? ""
                    searchText = mainClothe.name ?? ""
                    searchText2 = mainClothe.brand ?? ""
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Please fill out all fields"), dismissButton: .default(Text("OK")))
            }
        }
}

