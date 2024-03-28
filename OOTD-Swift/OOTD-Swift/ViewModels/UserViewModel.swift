//
//  UserViewModel.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/21/24.
//

import Foundation
import FirebaseFirestore


class UserViewModel: ObservableObject {

    @Published var user = User(uid: "tempUID", email: "tempEmail", password: "tempPass")

    private var db = Firestore.firestore()
    
    func setInitData(newUser: User) {
        user = newUser
        if (newUser.uid == "") {
            print("user id not defined UserViewModel.swift:addnewData()")
        }
        do {
            var set = try db.collection("users").document(newUser.uid).setData([
                "uid": newUser.uid,
                "email": newUser.email,
                "name": newUser.name ?? "",
                "creation_date": newUser.creationDate?.description ?? "",
                "username": newUser.username ?? "",
                "clothes": newUser.clothes,
                "outfits": newUser.outfits,
                "friendsId": newUser.friendsId,
                "friendsRequestsId": newUser.friendsRequestId,
                "postsId": newUser.postsId,
                "password": newUser.password
            ])
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func getAllData(uid: String) {
        
    }

    func addNewData(name: String) {
        
    }
        
}
