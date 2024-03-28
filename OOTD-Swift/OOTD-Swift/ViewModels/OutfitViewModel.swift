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
    
    func addFitToFavorites(outfit: Outfit) {
        let userId = Auth.auth().currentUser?.uid ?? ""
        let userRef = db.collection("users").document(userId)
        
        userRef.updateData([
            "favoriteFits": FieldValue.arrayUnion([outfit.id])
        ]) { error in
            if let error = error {
                print("Error updating user document: \(error)")
            } else {
                print("User document updated successfully!")
            }
        }
        
    }
    func editOutfit(outfit: Outfit) {

        let clothRef = db.collection("outfits").document(outfit.id)

        clothRef.setData(outfit.dictionary, merge: true) { error in
            if let error = error {
                print("Error updating cloth document: \(error)")
            } else {
                print("Cloth document updated successfully!")
            }
        }
    }
    
    func deleteFit(outfit: Outfit) {
        let userId = Auth.auth().currentUser?.uid ?? ""
        let fitUUID = outfit.id
        
        let userRef = db.collection("users").document(userId)
        userRef.updateData(["outfits": FieldValue.arrayRemove([fitUUID])]) { error in
            if let error = error {
                print("Error removing cloth from user's cloth array: \(error)")
            } else {
                print("Cloth removed from user's cloth array successfully")
            }
        }
        userRef.updateData([
                "favoriteFits": FieldValue.arrayRemove([fitUUID])
            ]) { error in
                if let error = error {
                    print("Error removing outfit from user's favorites: \(error)")
                } else {
                    print("Outfit removed from user's favorites successfully")
                }
            }
        let fitRef = db.collection("outfits").document(fitUUID)
        fitRef.delete {
            error in
            if let error = error {
                print("error removing fit document: \(error)")
            } else {
                print("Outfit Document deleted successfully")
            }
        }
        
    }
    
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
