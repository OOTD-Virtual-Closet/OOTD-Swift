//
//  PostViewModel.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/17/24.
import SwiftUI
import Firebase
import FirebaseFirestore

class PostViewModel: ObservableObject {
    let db = Firestore.firestore()
    
    func addPostToCurrentUser(post: Post) {
        if let userId = Auth.auth().currentUser?.uid {
            let userRef = db.collection("users").document(userId)
            // Step 1: Add the cloth document to Firestore
            let postRef = db.collection("posts").document(post.id)
            postRef.setData(post.dictionary) { error in
                if let error = error {
                    print("Error adding post document: \(error)")
                } else {
                    print("post document added successfully!")
                    
                    // Step 2: Update the current user's document
                    userRef.updateData([
                        "postsId": FieldValue.arrayUnion([post.id])
                    ]) { error in
                        if let error = error {
                            print("Error updating user document: \(error)")
                        } else {
                            print("User document updated successfully!")
                        }
                    }
                }
            }
        } else {
            print("User not authenticated")
        }
    }
}

extension Post {
    var dictionary: [String: Any] {
        return [
            "id": id,
            "owner": owner,
            "image": image ?? Date(),
            "caption": caption ?? []
        ]
    }
}
