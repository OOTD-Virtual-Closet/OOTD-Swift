//
//  SendFriendRequestView.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/28/24.
//

import SwiftUI
import FirebaseFirestore
import Combine

struct SendFriendRequestView: View {
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var allUsers : [String]?
    
    func populateArrays(with searchText: String) {
         let db = Firestore.firestore()
         
         db.collection("users")
            .whereField("email", isEqualTo: searchText.lowercased())
             .getDocuments { querySnapshot, error in
                 if let error = error {
                     print("Error fetching user documents: \(error.localizedDescription)")
                     return
                 }

                 if let querySnapshot = querySnapshot {
                     allUsers = querySnapshot.documents.map { $0.documentID }
                 }
             }
     }
    func sendFriendRequest(userB: String) {
        let db = Firestore.firestore()
        var userA = UserDefaults.standard.string(forKey: "uid") ?? "uid"
        
        // Update recipient user's document (add current user's UUID to friendRequestsReceived)
        let recipientUserRef = db.collection("users").document(userB)
        recipientUserRef.updateData([
            "friendRequestsReceived": FieldValue.arrayUnion([userA])
        ]) { error in
            if let error = error {
                print("Error sending friend request to \(userB): \(error.localizedDescription)")
                return
            }
            print("Friend request sent to user \(userB)")
        }
        
        // Update current user's document (add recipient user's UUID to friendRequestsSent)
        let currentUserRef = db.collection("users").document(userA)
        currentUserRef.updateData([
            "friendRequestsSent": FieldValue.arrayUnion([userB])
        ]) { error in
            if let error = error {
                print("Error updating friend requests sent by \(userA): \(error.localizedDescription)")
                return
            }
            print("Friend request sent by user \(userA)")
        }
    }
    
    var body: some View {
        ZStack (alignment: .top) {
                ScrollView {
                    VStack {
                        ZStack {
                                    TextField("", text: $searchText, onEditingChanged: { editing in
                                        isEditing = editing
                                    })
                                    .padding(.leading, 30)
                                    .frame(width: UIScreen.main.bounds.width - 90, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color(hex: "F4F4F4"))
                                            .padding(.leading, 15)
                                    )
                                    .overlay(
                                        HStack {
                                            Image(systemName: "magnifyingglass")
                                                .resizable()
                                                .foregroundColor(.black)
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                .padding(.leading, 27)
                                            Text("Search...")
                                                .foregroundColor(.black)
                                                .font(.system(size: 17))
                                                .fontWeight(.heavy)
                                                .padding(.leading, 5)
                                            Spacer()
                                        }
                                        .opacity(isEditing || !searchText.isEmpty ? 0 : 1)
                                    )
                                }
                                VStack(spacing: 20) {
                                    ForEach(allUsers ?? [], id: \.self) { use in
                                        Button(action: {
                                            sendFriendRequest(userB: use)
                                        }) {
                                            FriendDisplay(userBID: use)
                                        }
                                    }
                                }.padding(.top, 20)
                    }

                }
                .onReceive(Just(searchText)) { searchText in
                            populateArrays(with: searchText)
                        }
                .padding (.top, 50)

            Rectangle()
                .foregroundColor(Color(hex: "9278E0"))
                .frame(height: UIScreen.main.bounds.height / 15)
                .ignoresSafeArea(.all)
            HStack {
               
                Spacer()
                Text("Friend Requests Sent")
                    .foregroundColor(.white)
                    .font(.system( size: 20))
                    .fontWeight(.bold)
                Spacer()
            }.padding(.top, 20)
        }
 
    }
}

