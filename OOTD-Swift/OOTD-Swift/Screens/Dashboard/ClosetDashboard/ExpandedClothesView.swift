//
//  ExpandedClothesView.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/1/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

import UIKit



struct ExpandedClothesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var mainClothe : Cloth
    @StateObject var imageLoader = ImageLoader() // Image load
    

//    func fetchClothFromFirestore() async {
//        let docRef = Firestore.firestore().collection("clothes").document(mainClothe.id)
//        do {
//            let document = try await docRef.getDocumentAsync()
//            if document.exists {
//                let fetchedCloth = try document.data(as: Cloth.self)
//                
//                self.mainClothe = fetchedCloth
//                print("Cloth successfully fetched")
//                
//                if let imageUrl = fetchedCloth.image, let url = URL(string: imageUrl) {
////                    let storageRef = Storage.storage().reference().child(imageUrl)
////                    let url = try await storageRef.downloadURLAsync()
//                    await imageLoader.loadImage(from: url)
//                }
//            } else {
//                print("Cloth document does not exist")
//            }
//        } catch {
//            print("Error fetching cloth document: \(error.localizedDescription)")
//        }
//    }
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
    @State var showAlert =  false
    @State var showSheet = false
    
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
                        VStack {
                            
                            VStack (alignment: .leading, spacing: 10){
                                Text("Item Name")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .font(.system( size: 18))
                                    .padding(.leading, 5)
                                Text(mainClothe.name ?? "name")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .font(.system( size: 15))
                                    .padding(.leading, 5)
         
                                Text("Brand")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .font(.system( size: 18))
                                    .padding(.leading, 5)
                                Text(mainClothe.brand ?? "brand")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .font(.system( size: 15))
                                    .padding(.leading, 5)
                                Text("Size")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .font(.system( size: 18))
                                    .padding(.leading, 5)
                                Text(mainClothe.size ?? "size")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .font(.system( size: 15))
                                    .padding(.leading, 5)
      
                            }
                            .padding(.horizontal)
                        }

                        
                    }
                    //buttons
                    HStack {
                        Button(action: {
                            showAlert.toggle()
                                }) {
                                    HStack(spacing: 10) {
                                        Image(systemName: "trash.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                        Text("Delete")
                                            .foregroundColor(.white)
                                    }
                                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                    .background(Color.red)
                                    .cornerRadius(10)
                                }
                        Button(action: {
                            showSheet.toggle()
                                }) {
                                    HStack(spacing: 10) {
                                        Image(systemName: "applepencil.gen1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                        Text("Edit")
                                            .foregroundColor(.white)
                                    }
                                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                }
                        Button(action: {
                            let clothViewModel = ClothViewModel()
                            clothViewModel.addClothToFavorites(cloth: mainClothe)
                            presentationMode.wrappedValue.dismiss()
                                }) {
                                    HStack(spacing: 10) {
                                        Image(systemName: "star.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                        Text("Favorite")
                                            .foregroundColor(.white)
                                    }
                                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                    .background(Color(hex: mainClothe.color ?? "9278E0"))
                                    .cornerRadius(10)
                                }

                        
                    }
                    .padding(.top,  75)
                    
                    
                }
                Rectangle()
                    .foregroundColor(Color(hex: mainClothe.color ?? "9278E0"))
                    .frame(height: UIScreen.main.bounds.height / 8)
                    .ignoresSafeArea(.all)
                HStack {
                   
                    Spacer()
                    Text("New Item")
                        .foregroundColor(.white)
                        .font(.system( size: 20))
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.top, 20)
                
            }
//            .onAppear {
//                Task {
//                    await fetchClothFromFirestore()
//                    print("Fetched Clothes: ExpandedClothesView")
//                }
//            }
            .onAppear {
                fetchClothFromFirestore {
                    print("Fetched Clothes: ExpandedClothesView")
                }
            }
            .sheet(isPresented: $showSheet) {
                EditClothesView(mainClothe: mainClothe)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("If any outfits contain this cloth, they will be deleted as well. Are you sure you want to proceed?"), primaryButton: .destructive(Text("Delete")) {
                    let clothViewModel = ClothViewModel()
                    clothViewModel.deleteCloth(cloth: mainClothe)
                    presentationMode.wrappedValue.dismiss()
                }, secondaryButton: .cancel(Text("Cancel")))
            }
    }
}

//extension DocumentReference {
//    func getDocumentAsync() async throws -> DocumentSnapshot {
//        try await withCheckedThrowingContinuation { continuation in
//            self.getDocument { snapshot, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else if let snapshot = snapshot {
//                    continuation.resume(returning: snapshot)
//                } else {
//                    continuation.resume(throwing: NSError(domain: "ExpandedClothesView", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"]))
//                }
//            }
//        }
//    }
//}
//
//extension StorageReference {
//    func downloadURLAsync() async throws -> URL {
//        try await withCheckedThrowingContinuation { continuation in
//            self.downloadURL { url, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else if let url = url {
//                    continuation.resume(returning: url)
//                } else {
//                    continuation.resume(throwing: NSError(domain: "ExpandedClothesView", code: -2, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"]))
//                }
//            }
//        }
//    }
//}


//struct ExpandedClothesViewPreview: PreviewProvider {
   // static var previews: some View {
     //   ExpandedClothesView()
  //  }
//}
