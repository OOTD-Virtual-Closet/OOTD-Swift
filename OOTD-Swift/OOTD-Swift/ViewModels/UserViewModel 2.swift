//
//  UserViewModel.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/21/24.
//

import Foundation
import FirebaseFirestore


class UserViewModel: ObservableObject {

    @Published var user = User()

    private var db = Firestore.firestore()

    func getAllData(uid: String) {
        
    }

    func addNewData(name: String) {
        user.uid = user.uid ?? ""
        if (user.uid == "") {
            print("user id not defined UserViewModel.swift:addnewData()")
        }
        do {
            var set = try db.collection("users").document(user.uid ?? "error").setData([
                    "uid":user.uid,
                    "email":user.email,
                    "name":user.name,
                    "username":user.username,
                    "creation_date":user.creationDate?.description
               ])

           }
           catch {
               print(error.localizedDescription)
           }
       }
}
