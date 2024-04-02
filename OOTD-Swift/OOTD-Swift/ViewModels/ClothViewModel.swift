//
//  ClothViewModel.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/28/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

class ClothViewModel: ObservableObject {
    let db = Firestore.firestore()
    
    func deleteCloth(cloth: Cloth) {
         let userUUID = Auth.auth().currentUser?.uid ?? "uid"
        let clothUUID = cloth.id
           let userRef = db.collection("users").document(userUUID)
           userRef.updateData(["clothes": FieldValue.arrayRemove([clothUUID])]) { error in
               if let error = error {
                   print("Error removing cloth from user's cloth array: \(error)")
               } else {
                   print("Cloth removed from user's cloth array successfully")
                   self.deleteClothDocument(cloth: cloth)
               }
           }
        userRef.updateData([
                "favorites": FieldValue.arrayRemove([clothUUID])
            ]) { error in
                if let error = error {
                    print("Error removing cloth from user's favorites: \(error)")
                } else {
                    print("cloth removed from user's favorites successfully")
                }
            }
       }
    
    func deleteClothDocument(cloth: Cloth) {
        let clothUUID = cloth.id
        let storageRef = Storage.storage().reference()
        let imageUUID = cloth.image
        
        let imageRef = storageRef.child("clothes/\(imageUUID ?? "")")
        
        imageRef.delete {
            error in
            if let error = error {
                        print("Error deleting image from Firebase Storage: \(error)")
                    } else {
                        print("Image deleted from Firebase Storage successfully")
                    }
        }

        let clothRef = db.collection("clothes").document(clothUUID)
        clothRef.delete {
            error in
            if let error = error {
                print("error removing cloth document: \(error)")
            } else {
                print("Cloth Document deleted successfully")
            }
        }
        let outfits = db.collection("outfits")
        outfits.getDocuments {
            (querySnapshot, error) in
            if let error = error {
                print("Error getting docuemts: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let outfitData = document.data()
                    let clothFields = ["cloth1", "cloth2", "cloth3", "cloth4"]

                    for field in clothFields {
                        if let clothID = outfitData[field] as? String, clothID == clothUUID {
                            outfits.document(document.documentID).delete { error in
                                if let error = error {
                                    print("error deleting outfit document when cloth found: \(error)")
                                } else {
                                    print("when cloth found, outfit was deleted successfully")
                                }
                            }
                            break
                        }
                    }
                     
                }
            }
        }
    }
    func editCloth(cloth: Cloth) {

        let clothRef = db.collection("clothes").document(cloth.id)

        // Update the cloth document with the new data
        clothRef.setData(cloth.dictionary, merge: true) { error in
            if let error = error {
                print("Error updating cloth document: \(error)")
            } else {
                print("Cloth document updated successfully!")
            }
        }
    }
    
    func addClothToFavorites(cloth: Cloth) {

        if let userId = UserDefaults.standard.string(forKey: "uid") {
            let userRef = db.collection("users").document(userId)
                    userRef.updateData([
                        "favorites": FieldValue.arrayUnion([cloth.id])
                    ]) { error in
                        if let error = error {
                            print("Error updating user document: \(error)")
                        } else {
                            print("User document updated successfully!")
                        }
                    }
                
            
        } else {
            print("User not authenticated")
        }
    }

    
    func addClothToCurrentUser(cloth: Cloth) {
        if let userId = UserDefaults.standard.string(forKey: "uid") {
            let userRef = db.collection("users").document(userId)

            let clothRef = db.collection("clothes").document(cloth.id)
            clothRef.setData(cloth.dictionary) { error in
                if let error = error {
                    print("Error adding cloth document: \(error)")
                } else {
                    print("Cloth document added successfully!")
                    
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
            "name" : name ?? "",
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
