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
    @State var owner: User?
    
    // Key for UserDefaults
    private let selectedReactionKey = "selectedReaction"
    
    func loadUser() {
        guard let userID = UserID else {
            print("Current user UID not found")
            return
        }
        
        let docRef = Firestore.firestore().collection("users").document(userID)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                do {
                    self.owner = try document.data(as: User.self)
                    print("User successfully fetched")
                } catch {
                    print("Error decoding user document: \(error.localizedDescription)")
                }
            } else {
                print("User document does not exist")
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
                
                Text(owner?.email ?? "user")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding(.leading, 20)
            
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
            }
            .padding(.leading, 20)
            
            HStack {
                Text(post?.caption ?? "")
                    .foregroundColor(.black)
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                
                if let selectedReaction = selectedReaction {
                    Button(action: {
                        // When the selected reaction is clicked again, set it to nil
                        // This will display the reaction list again
                        if selectedReaction == self.selectedReaction {
                            self.selectedReaction = nil
                            UserDefaults.standard.removeObject(forKey: selectedReactionKey) // Remove stored reaction
                        }
                    }) {
                        Text(selectedReaction)
                            .font(.title2)
                    }
                } else {
                    ForEach(["🔥", "👍", "😂"], id: \.self) { emoji in
                        Button(action: {
                            selectedReaction = emoji
                            UserDefaults.standard.set(emoji, forKey: selectedReactionKey) // Save selected reaction
                            reactToPost(postID: item, reaction: emoji)
                        }) {
                            Text(emoji)
                                .font(.subheadline)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.leading, 25)
        }
        .onAppear {
            loadUser()
            fetchPostFromFirestore {
                print("fetched post and stuff")
            }
            // Retrieve selected reaction from UserDefaults on appearance
            if let storedReaction = UserDefaults.standard.string(forKey: selectedReactionKey) {
                selectedReaction = storedReaction
            }
        }
    }
    
    func reactToPost(postID: String, reaction: String) {
        guard let currentUserUID = UserID else {
            print("Current user UID not found")
            return
        }
        
        let db = Firestore.firestore()
        let reactionData: [String: Any] = [
            "userUID": currentUserUID,
            "reaction": reaction
        ]
        
        let postRef = db.collection("posts").document(postID)
        let reactionsCollectionRef = postRef.collection("reactions")
        
        // Check if the user has already reacted to this post
        reactionsCollectionRef.whereField("userUID", isEqualTo: currentUserUID).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching existing reactions: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            if snapshot.documents.isEmpty {
                // If the user has not reacted yet, add a new reaction
                reactionsCollectionRef.addDocument(data: reactionData) { error in
                    if let error = error {
                        print("Error adding reaction to post \(postID): \(error.localizedDescription)")
                    } else {
                        print("Reaction added successfully to post \(postID)")
                    }
                }
            } else {
                // If the user has already reacted, update their existing reaction
                guard let existingReactionDoc = snapshot.documents.first else { return }
                existingReactionDoc.reference.updateData(reactionData) { error in
                    if let error = error {
                        print("Error updating existing reaction: \(error.localizedDescription)")
                    } else {
                        print("Existing reaction updated successfully")
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
                    self.post = try document.data(as: Post.self)
                    print("Post successfully fetched")
                    
                    if let imageUrl = post?.image {
                        let storageRef = Storage.storage().reference()
                        storageRef.child(imageUrl).downloadURL { url, error in
                            if let url = url {
                                imageLoader.loadImage(from: url)
                            } else if let error = error {
                                print("Error downloading image: \(error.localizedDescription)")
                            }
                            completion()
                        }
                    } else {
                        completion()
                    }
                } catch {
                    print("Error decoding post document: \(error.localizedDescription)")
                    completion()
                }
            } else {
                print("post document does not exist")
                completion()
            }
        }
    }
}
