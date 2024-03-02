//
//  OutfitViewModel.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/1/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class OutfitViewModel: ObservableObject {
    let db = Firestore.firestore()
    
    func addOutfitToCurrentUser(outfit: Outfit) {
        if let userId = Auth.auth().currentUser?.uid {
            let userRef = db.collection("users").document(userId)

            // Step 1: Add the cloth document to Firestore
            let clothRef = db.collection("outfits").document(outfit.id)
            clothRef.setData(outfit.dictionary) { error in
                if let error = error {
                    print("Error adding outfit document: \(error)")
                } else {
                    print("outfit document added successfully!")
                    
                    // Step 2: Update the current user's document
                    userRef.updateData([
                        "outfits": FieldValue.arrayUnion([outfit.id])
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

extension Outfit {
    var dictionary: [String: Any] {
        return [
            "id": id,
            "name": name ?? "",
            "genre": genre ?? "",
            "cloth1": cloth1 ?? "",
            "cloth2": cloth2 ?? "",
            "cloth3": cloth3 ?? "",
            "cloth4": cloth4 ?? ""
        ]
    }
}
