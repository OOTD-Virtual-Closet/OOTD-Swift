//
//  FriendProfile.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 4/19/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import PhotosUI
import UIKit



struct FriendProfile: View {
    @Environment(\.presentationMode) var presentationMode

    
    @State private var selectedStyle: String?
    
    @State var selectedImage: UIImage?
    @State var uid : String


    @State var name : String?
    @State var email: String?
    
    @State var color = Color(hex: "9278E0")
    @StateObject var imageLoader = ImageLoader()
    @State var pinnedOne : String?
    @State var pinnedTwo : String?
    @State var pinnedThree : String?
    func populatePinnedOutfits(completion: @escaping (Error?) -> Void) {
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        userRef.getDocument { document, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let document = document else {
                let error = NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document not found"])
                completion(error)
                return
            }
            if let imageUrl = document.data()?["name"] as? String? ?? "" {
                let storageRef = Storage.storage().reference()
                storageRef.child(imageUrl).downloadURL { url, error in
                    if let url = url {
                        // Load image using image loader
                        imageLoader.loadImage(from: url)
                    } else if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    }
                }
            }
            let name1 = document.data()?["email"] as? String ?? ""
            email = name1
            let username1 = document.data()?["username"] as? String ?? ""
            name = username1

            let pinnedFits = document.data()?["pinnedFits"] as? [String] ?? []
            
            // Populate state variables pinnedone, pinnedtwo, and pinnedthree
            pinnedOne = pinnedFits.indices.contains(0) ? pinnedFits[0] : nil
            pinnedTwo = pinnedFits.indices.contains(1) ? pinnedFits[1] : nil
            pinnedThree = pinnedFits.indices.contains(2) ? pinnedFits[2] : nil
            
            completion(nil)
        }
    }




    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false){
                VStack {
                    if let image = imageLoader.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .padding(.top, 150)
                        
                    } else {
                        Image("UserIcon") // Your user's profile picture
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .padding(.top, 150)
                    }
                    
                    
                    
                    Text(name ?? "Aaryan Srivastava")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .padding(.top, 5)
                    VStack {
                        HStack {
                            
                            
                            if pinnedOne != nil && pinnedOne != "" {
                                OutfitsPinned(item: pinnedOne!)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                            } else {
                           
                            }
                            
                            
                            
                            
                            
                            if pinnedTwo != nil && pinnedTwo != "" {
                                OutfitsPinned(item: pinnedTwo!)
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                            } else {
                               
                            }
                            
                            
                            
                            
                            
                            if pinnedThree != nil  && pinnedThree != "" {
                                OutfitsPinned(item: pinnedThree!)
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                            } else {
                             
                            }
                            
                        }
                        
                        HStack {
                            Text("Email: ") // Display the user's email
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                                .padding(.top, 5)
                            Spacer()
                            Text(email ?? "test1@gmail.com")
                                .fontWeight(.medium)
                                .foregroundColor(color)

                        }
                        
                    }
                    .padding(.bottom, 45)
                    .padding(.top, 25)
                    
                    Spacer() // Pushes everything to the top
                }
                .padding(.horizontal)
            }
            Rectangle()
                .foregroundColor(color)
                .frame(height: UIScreen.main.bounds.height / 9)
                .ignoresSafeArea(.all)

            HStack {
                Spacer()
                Text("Friend Summary")
                    .foregroundColor(.white)
                    .font(.system( size: 20))
                    .fontWeight(.bold)
                    .padding(.top, 20)
                Spacer()
            }
        }
            .onAppear {
                populatePinnedOutfits { error in
                                   if let error = error {
                                       print("Error populating pinned outfits: \(error.localizedDescription)")
                                   } else {
                                       print("Pinned outfits populated successfully")
                                   }
                               }

                
            }
                
            }

        }




