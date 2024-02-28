//
//  ClothViewModel.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/28/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class ClothViewModel: ObservableObject {
    let db = Firestore.firestore()
    
    func addClothToCurrentUser(cloth: Cloth) {
        if let userId = Auth.auth().currentUser?.uid {
            let userRef = db.collection("users").document(userId)

            // Step 1: Add the cloth document to Firestore
            let clothRef = db.collection("clothes").document(cloth.id)
            clothRef.setData(cloth.dictionary) { error in
                if let error = error {
                    print("Error adding cloth document: \(error)")
                } else {
                    print("Cloth document added successfully!")
                    
                    // Step 2: Update the current user's document
                    userRef.updateData([
                        "clothes": FieldValue.arrayUnion([cloth.id])
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

extension Cloth {
    var dictionary: [String: Any] {
        return [
            "id": id,
            "type": type ?? "",
            "size": size ?? "",
            "color": color ?? "",
            "brand": brand ?? "",
            "image": image ?? Date(), 
            "tags": tags ?? []
        ]
    }
}
