//
//  BlockedListView.swift
//  OOTD-Swift
//
//  Created by Atharva Gupta on 4/18/24.
//
import SwiftUI
import FirebaseFirestore

struct BlockedListView: View {
    @State private var searchText = ""
    @State private var isEditing = false
    
    @State var blockedUsersList : [String]?
    
    func populateBlockedUsersList() {
        let db = Firestore.firestore()
        var userA = UserDefaults.standard.string(forKey: "uid") ?? "uid"
        
        let userRef = db.collection("users").document(userA)
        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                // Extract blockedUsers array from user document
                if let blockedUsers = document.data()?["blockedUsers"] as? [String] {
                    // Update blockedUsersList
                    blockedUsersList = blockedUsers
                } else {
                    print("blockedUsers field not found or not of type [String]")
                }
            } else {
                print("User document not found")
            }
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
                        ForEach(blockedUsersList ?? [], id: \.self) { blockedUserID in
                            BlockedUserDisplay(blockedUserID: blockedUserID)
                        }
                    }.padding(.top, 20)
                }
                Rectangle()
                    .foregroundColor(Color.white)
                    .frame(height: 100)
                    .ignoresSafeArea(.all)
            }.padding (.top, 50)
            
            Rectangle()
                .foregroundColor(Color(hex: "9278E0"))
                .frame(height: UIScreen.main.bounds.height / 10)
                .ignoresSafeArea(.all)
            HStack {
                Spacer()
                Text("Blocked Users")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                Spacer()
            }.padding(.top, 20)
        }
        .onAppear {
            populateBlockedUsersList()
        }
    }
}

struct BlockedUserDisplay: View {
    var blockedUserID: String
    
    @State private var friendName: String?
    @State private var isUnblockAlertPresented = false
    
    func loadFriendName() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(blockedUserID)
        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                // Extract friend's name from user document
                if let name = document.data()?["email"] as? String {
                    friendName = name
                }
            }
        }
    }
    
    func unblockUser() {
        let db = Firestore.firestore()
        var userA = UserDefaults.standard.string(forKey: "uid") ?? "uid"
        
        // Update userA's document to remove the blocked user from blockedUsers list
        let userRef = db.collection("users").document(userA)
        userRef.updateData([
            "blockedUsers": FieldValue.arrayRemove([blockedUserID])
        ]) { error in
            if let error = error {
                print("Error removing user from blocked list: \(error.localizedDescription)")
            } else {
                print("User unblocked successfully!")
                
                // After unblocking, add the unblocked user to userA's friends list
                let friendRef = db.collection("users").document(userA)
                friendRef.updateData([
                    "friends": FieldValue.arrayUnion([blockedUserID])
                ]) { error in
                    if let error = error {
                        print("Error adding unblocked user to friends list: \(error.localizedDescription)")
                    } else {
                        print("Unblocked user added to friends list successfully!")
                    }
                }
            }
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(hex: "E1DDED"))
                .frame(width: UIScreen.main.bounds.width - 40, height: 60)
            HStack {
                if let name = friendName {
                    Text("\(name)")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                } else {
                    Text("Loading...")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .onAppear {
                            loadFriendName()
                        }
                }
                
                Button(action: {
                    isUnblockAlertPresented = true
                }) {
                    Text("Unblock")
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                Spacer()
                .alert(isPresented: $isUnblockAlertPresented) {
                    Alert(
                        title: Text("Unblock User"),
                        message: Text("Are you sure you want to unblock this user?"),
                        primaryButton: .default(Text("Yes")) {
                            unblockUser()
                        },
                        secondaryButton: .cancel()
                    )
                }
                
            }
            .padding(.leading, 40)
        }
    }
}
