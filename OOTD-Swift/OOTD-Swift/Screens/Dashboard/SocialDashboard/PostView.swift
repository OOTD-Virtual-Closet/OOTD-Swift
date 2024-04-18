//
//  PostView.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/18/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct PostView: View {
    let item: String // UUID of the cloth document
    @State var UserID: String?
    @State private var selectedReaction: String?
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
                
                if selectedReaction == nil {
                        ForEach(["🔥", "👍", "😂"], id: \.self) { emoji in
                            Button(action: {
                                selectedReaction = emoji
                                reactToPost(postID: item, reaction: emoji)
                            }) {
                                Text(emoji)
                                    .font(.subheadline)
                            }
                        }
                } else {
                    Text(selectedReaction ?? "")
                        .font(.title2)
                }
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
    
    func reactToPost(postID: String, reaction: String) {
        guard let currentUserUID = UserID else {
            print("Current user UID not found")
            return
        }
        
        let db = Firestore.firestore()
        
        // Add the reaction to the post document
        let reactionData: [String: Any] = [
            "userUID": currentUserUID,
            "reaction": reaction
        ]
        
        let postRef = db.collection("posts").document(postID)
        let reactionsCollectionRef = postRef.collection("reactions")
        
        reactionsCollectionRef.addDocument(data: reactionData) { error in
            if let error = error {
                print("Error adding reaction to post \(postID): \(error.localizedDescription)")
            } else {
                print("Reaction added successfully to post \(postID)")
                
                let userRef = db.collection("users").document(post?.owner ?? "")
                let postReactionsCollectionRef = userRef.collection("postReactions").document(postID)
                
                postReactionsCollectionRef.setData(reactionData) { error in
                    if let error = error {
                        print("Error updating user document with reaction: \(error.localizedDescription)")
                    } else {
                        print("User document updated with reaction")
                    }
                }
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
