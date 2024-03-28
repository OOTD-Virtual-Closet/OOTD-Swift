//
//  FriendRequestView.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/28/24.
//

import SwiftUI
import FirebaseFirestore

struct FriendRequestView: View {
    @State private var searchText = ""
    @State private var isEditing = false
    
    @State var friendRequestsList : [String]?
    
    
    func populateFriendRequestsList() {
            let db = Firestore.firestore()
            
            // Replace "userDocumentID" with the actual document ID of the user
        var userA = UserDefaults.standard.string(forKey: "uid") ?? "uid"

            let userRef = db.collection("users").document(userA)
            userRef.getDocument { document, error in
                if let error = error {
                    print("Error fetching user document: \(error.localizedDescription)")
                    return
                }

                if let document = document, document.exists {
                    // Extract friendRequestsSent array from user document
                    if let friendRequestsSent = document.data()?["friendRequestsSent"] as? [String] {
                        // Update friendRequestsList
                        friendRequestsList = friendRequestsSent
                    } else {
                        print("friendRequestsSent field not found or not of type [String]")
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
                                    ForEach(friendRequestsList ?? [], id: \.self) { test in
                                        RequestSentDisplay(userBID: test)
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
                Text("Friend Requests Sent")
                    .foregroundColor(.white)
                    .font(.system( size: 20))
                    .fontWeight(.bold)
                Spacer()
            }.padding(.top, 20)
        }
        .onAppear {
            populateFriendRequestsList()
        }
 
    }
}
