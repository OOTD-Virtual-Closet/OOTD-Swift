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
                                Text("Color")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .font(.system( size: 18))
                                    .padding(.leading, 5)
                                Text(mainClothe.color ?? "color")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .font(.system( size: 15))
                                    .padding(.leading, 5)
      
                            }
                            .padding(.horizontal)
                        }

                        
                    }
                }
                Rectangle()
                    .foregroundColor(Color(hex: "9278E0"))
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
                
            }.onAppear {
                fetchClothFromFirestore {
                    print("fetched cloth and stuff")
                }
            }
        }
}


//struct ExpandedClothesViewPreview: PreviewProvider {
   // static var previews: some View {
     //   ExpandedClothesView()
  //  }
//}
