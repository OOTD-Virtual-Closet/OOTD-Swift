//
//  Clothes.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/1/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

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

    
    
     func fetchClothFromFirestore(completion: @escaping () -> Void) {
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
