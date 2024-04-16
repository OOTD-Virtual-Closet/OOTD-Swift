//
//  PostView.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/18/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct PostReactions: Identifiable, Codable {
    var id: String
    var owner: String
    var content: String
    var reactions: [Reaction]
}

struct Reaction: Identifiable, Codable {
    var id: String
    var type: ReactionType
}

enum ReactionType: String, Codable {
    case like
    case love
    case laugh
}

struct PostView: View {
    let item: String // UUID of the cloth document
    @State var UserID: String?
    @State var Owner : User?
    func loadUser(completion: @escaping () -> Void) {
        
        let docRef = Firestore.firestore().collection("users").document(UserID ?? "")
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                do {
                    Owner = try document.data(as: User.self)
                    print("User successfully fetched")
                    
                    
                } catch {
                    print("Error decoding user document: \(error.localizedDescription)")
                    completion()
                }
            } else {
                print("User document does not exist")
                completion()
            }
        }
    }

    
    @State var post: Post? // Cloth object fetched from Fire
    
    @StateObject var imageLoader = ImageLoader() // Image load
    var body: some View {
        VStack {
            HStack {
                Image("UserIcon")
                    .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                Text(Owner?.email ?? "user")
                    .foregroundColor(.black)
                    .font(.system( size: 15))
                    .fontWeight(.bold)
                Spacer()
            }.padding(.leading, 20)
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(hex: "E1DDED"))
                    .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                    .overlay(
                            Group {
                                                    if let image = imageLoader.image {
                                                        Image(uiImage: image)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(height: 300)
                                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                                    } else {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .foregroundColor(Color(hex: "E1DDED"))
                                                            .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                                                    }
                                                }
                    )
                Spacer()
            }.padding(.leading, 20)
            HStack {
                Text(post?.caption ?? "")
                    .foregroundColor(.black)
                    .font(.system( size: 12))
                    .fontWeight(.semibold)
                Spacer()
            }.padding(.leading, 25)

        }
        .onAppear {
            fetchPostFromFirestore {
                print("fetched post and stuff")
            }
            loadUser {
                print(".")
            }
        }
    }

    
    
     func fetchPostFromFirestore(completion: @escaping () -> Void) {
        let docRef = Firestore.firestore().collection("posts").document(item)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                do {
                    post = try document.data(as: Post.self)
                    print("Post successfully fetched")
                    
                    if let imageUrl = post?.image {
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
                    print("Error decoding post document: \(error.localizedDescription)")
                    completion() // Call completion handler if error occurs during decoding
                }
            } else {
                print("post document does not exist")
                completion() // Call completion handler if document does not exist
            }
        }
    }
}
