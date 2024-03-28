//
//  EditOutfitsView.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/28/24.
//
import SwiftUI
import FirebaseStorage
import FirebaseFirestore

import UIKit

struct EditOutfitsView: View {
    @Environment(\.presentationMode) var presentationMode
    
       @State var mainOutfit : Outfit
    @StateObject var imageLoader = ImageLoader()
    @StateObject var imageLoader2 = ImageLoader()
    @StateObject var imageLoader3 = ImageLoader()
    @StateObject var imageLoader4 = ImageLoader()
    @State  var searchText = ""
    @State  var selectedGenre : String?
    @State  var isEditing = false
     var genreOptions = ["Streetwear", "Formalwear", "Casual", "Business Casual", "Pajamas"]
    @State var showAlert = false


    
    func fetchFitFromFirestore(completion: @escaping () -> Void) {
        let docRef = Firestore.firestore().collection("outfits").document(mainOutfit.id)
       docRef.getDocument { document, error in
           if let document = document, document.exists {
               do {
                   mainOutfit = try document.data(as: Outfit.self)
                   print("Outfit successfully fetched")
                   
                   let cloths = [mainOutfit.cloth1, mainOutfit.cloth2, mainOutfit.cloth3, mainOutfit.cloth4].compactMap { $0 }
                   for (index, clothID) in cloths.enumerated() {
                       let counter = index + 1
                       let clothDocRef = Firestore.firestore().collection("clothes").document(clothID)
                       clothDocRef.getDocument { clothDocument, clothError in
                           if let clothDocument = clothDocument, clothDocument.exists {
                               do {
                                   let cloth = try clothDocument.data(as: Cloth.self)
                                   if let imageUrl = cloth.image {
                                       let storageRef = Storage.storage().reference()
                                       storageRef.child(imageUrl).downloadURL { url, error in
                                           if let url = url {
                                               switch counter {
                                               case 1:
                                      
                                                   imageLoader.loadImage(from: url)
                                               case 2:
                                              
                                                   imageLoader2.loadImage(from: url)
                                               case 3:
                                                 
                                                   imageLoader3.loadImage(from: url)
                                               case 4:
                                                   
                                                   imageLoader4.loadImage(from: url)
                                               default:
                                                   break
                                               }
                                           } else if let error = error {
                                               print("Error downloading image: \(error.localizedDescription)")
                                           }
                                       }
                                   }
                               } catch {
                                   print("Error decoding cloth document: \(error.localizedDescription)")
                               }
                           } else {
                               print("Cloth document \(clothID) does not exist")
                           }
                       }
                   }
                  
                  
                  
                  
               } catch {
                   print("Error decoding outfit document: \(error.localizedDescription)")
                   completion() // Call completion handler if error occurs during decoding
               }
           } else {
               print("outfit document does not exist")
               completion() // Call completion handler if document does not exist
           }
       }
   }
     
    var body: some View {
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false){
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(height: 100)
                    HStack  {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(hex: "E1DDED"))
                            .frame(width: 220, height: 300)
                            .overlay(
                                    Group {
                                           if let image = imageLoader.image {
                                              Image(uiImage: image)
                                                     .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .foregroundColor(Color(hex: "E1DDED"))
                                                    .frame(width:80, height: 80)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                                    .offset(x: -60, y: -60)

                                               if let image2 = imageLoader2.image {
                                                           Image(uiImage: image2)
                                                               .resizable()
                                                               .aspectRatio(contentMode: .fill)
                                                               .frame(width:80, height: 80)
                                                               .clipShape(RoundedRectangle(cornerRadius: 10))
                                                               .offset(x: -20, y: -20)
                                                       }
                                               if let image3 = imageLoader3.image {
                                                           Image(uiImage: image3)
                                                               .resizable()
                                                               .aspectRatio(contentMode: .fill)
                                                               .frame(width:80, height: 80)
                                                               .clipShape(RoundedRectangle(cornerRadius: 10))
                                                               .offset(x: 20, y: 20)
                                                       }
                                               if let image4 = imageLoader4.image {
                                                           Image(uiImage: image4)
                                                               .resizable()
                                                               .aspectRatio(contentMode: .fill)
                                                               .frame(width:80, height: 80)
                                                               .clipShape(RoundedRectangle(cornerRadius: 10))
                                                               .offset(x: 60, y: 60)
                                                       }
                                        } else {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color(hex: "E1DDED"))
                                                .frame(width: 170, height: 250)
                                                .overlay(
                                                    Text("loading...")
                                                        .foregroundColor(.white)
                                                        .font(.headline)
                                            )
                                        }
                                      }
                            )
                        VStack {
                            
                            VStack (alignment: .leading, spacing: 10){
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
                            .padding(.horizontal)
                        }

                        
                    }

                        Button(action: {
                            if searchText == "" || selectedGenre == nil {
                                showAlert = true
                            } else {
                                showAlert = false
                                let outfit = Outfit(id: mainOutfit.id, name: searchText ?? "", genre: selectedGenre ?? "", cloth1: mainOutfit.cloth1 , cloth2: mainOutfit.cloth2, cloth3: mainOutfit.cloth3 , cloth4: mainOutfit.cloth4)
                                
                                let outfitViewModel = OutfitViewModel()
                                outfitViewModel.editOutfit(outfit: outfit)
                                presentationMode.wrappedValue.dismiss()
                                
                            }

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
                .padding(.top, 20)
                Rectangle()
                    .foregroundColor(Color(hex: "9278E0"))
                    .frame(height: UIScreen.main.bounds.height / 8)
                    .ignoresSafeArea(.all)
                HStack {
                   
                    Spacer()
                    Text("Edit Outfit")
                        .foregroundColor(.white)
                        .font(.system( size: 20))
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.top, 20)
                
            }
            .onAppear {
                fetchFitFromFirestore {
                    print("fetched fit and stuff")
                    searchText = mainOutfit.name
                    selectedGenre = mainOutfit.genre
                    
                }
                
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Please fill out all fields"), dismissButton: .default(Text("OK")))
            }
        }
}
