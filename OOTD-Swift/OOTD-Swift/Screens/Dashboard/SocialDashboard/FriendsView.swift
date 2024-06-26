//
//  FriendsView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
struct FriendsView: View {
    @State var showRequestsReceived = false
    @State var showRequestsSent = false
    @State var showBlockedList = false
    @State private var searchText = ""
    @State private var isEditing = false
    @State var showAddFriends = false
    @State var friendsList : [String]?
    @State var showFriendProfile = false
    @State var friendURL : String?
    
    func populateFriendsList() {
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
                if let friendRequestsSent = document.data()?["friends"] as? [String] {
                    // Update friendRequestsList
                    friendsList = friendRequestsSent
                } else {
                    print("friendRequestsSent field not found or not of type [String]")
                }
            } else {
                print("User document not found")
            }
        }
    }
    
    func reloadFriendList() {
        populateFriendsList()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack {
                    HStack {
                        Text("\(friendsList?.count ?? 0) \(friendsList?.count == 1 ? "Friend" : "Friends")")
                            .padding()
                            .font(.headline)
                            .foregroundColor(.black)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                        Image(systemName: "person.2.fill")
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                        Button(action: {
                            showAddFriends.toggle()
                        }) {
                            Text("Add Friend")
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    HStack {
                        Text("Friend List:")
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .padding(.top, 20)
                    Rectangle()
                        .foregroundColor(Color.gray)
                        .frame(height: 0.5)
                        .padding(.horizontal, 20)
                    VStack(spacing: 20) {
                        ForEach(friendsList ?? [], id: \.self) { friendID in
                            Button(action: {
                                showFriendProfile.toggle()
                                friendURL = friendID
                            }) {
                                FriendDisplay(userBID: friendID)
                            }
                        }
                    }
                    .padding(.top, 20)
                }
                Rectangle()
                    .foregroundColor(Color.white)
                    .frame(height: 100)
                    .ignoresSafeArea(.all)
            }.padding (.top, 50)
            HStack {
                Spacer()
                Button(action: {
                    showRequestsReceived.toggle()
                }) {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color.purple)
                        .frame(width:50, height: 50)
                        .overlay(
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        )
                }
                Button(action: {
                    print("Blocked user list")
                    showBlockedList.toggle()
                }) {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color.purple)
                        .frame(width:50, height: 50)
                        .overlay(
                            Image(systemName: "person.2.slash")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        )
                }
                Button(action: {
                    showRequestsSent.toggle()
                }) {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color.purple)
                        .frame(width:50, height: 50)
                        .overlay(
                            Image(systemName: "paperplane")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        )
                }
                
                
            }.padding(.trailing, 20)
                .padding(.bottom, 70)
            
        }
        .onAppear {
            populateFriendsList()
        }
        .sheet(isPresented: $showFriendProfile) {
            FriendProfile(uid: friendURL ?? "uid")
        }
        .sheet(isPresented: $showRequestsReceived)
        {
            FriendReceivedView()
        }
        .sheet(isPresented: $showRequestsSent)
        {
            FriendRequestView()
        }
        .sheet(isPresented: $showBlockedList)
        {
            BlockedListView()
        }
        .sheet(isPresented: $showAddFriends, onDismiss: {
            reloadFriendList()
        })
        {
            SendFriendRequestView()
        }
    }
}

struct FriendDisplay: View {
    @State var userBID : String?
    @State var userB: User?
    @State var friendsList: [String]?
    @State var showAlert = false
    @StateObject var imageLoader = ImageLoader()
    
    func loadUser(completion: @escaping () -> Void) {
        let docRef = Firestore.firestore().collection("users").document(userBID ?? "")
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                do {
                    userB = try document.data(as: User.self)
                    print("User successfully fetched")
                    if let imageUrl = userB?.name {
                        let storageRef = Storage.storage().reference()
                        storageRef.child(imageUrl).downloadURL { url, error in
                            if let url = url {
                                // Load image using image loader
                                imageLoader.loadImage(from: url)
                            } else if let error = error {
                                print("Error downloading image: \(error.localizedDescription)")
                            }
                            completion() // Call completion handler after fetching image
                        }
                    } else {
                        completion() // Call completion handler if image URL is nil
                    }
                } catch {
                    print("Error decoding user document: \(error.localizedDescription)")
                    completion()
                }
            } else {
                print("User document does not exist")
                completion()
            }
        }
    }
    
    func removeFriend() {
        guard let friendToRemoveID = userBID else { return }
        // Remove friend from Firestore
        let db = Firestore.firestore()
        var userA = UserDefaults.standard.string(forKey: "uid") ?? "uid"
        
        let userRef = db.collection("users").document(userA)
        userRef.updateData([
            "friends": FieldValue.arrayRemove([friendToRemoveID])
        ]) { error in
            if let error = error {
                print("Error removing friend: \(error.localizedDescription)")
            } else {
                print("Friend removed successfully!")
                // Update local friends list after removal
                if let index = friendsList?.firstIndex(of: friendToRemoveID) {
                    friendsList?.remove(at: index)
                }
            }
        }
    }
    
    func blockUser() {
        guard let userToBlockID = userBID else { return }
        
        let db = Firestore.firestore()
        var userA = UserDefaults.standard.string(forKey: "uid") ?? "uid"
        
        let userRef = db.collection("users").document(userA)
        userRef.updateData([
            "blockedUsers": FieldValue.arrayUnion([userToBlockID])
        ]) { error in
            if let error = error {
                print("Error blocking user: \(error.localizedDescription)")
            } else {
                print("User blocked successfully!")
                
                if let index = friendsList?.firstIndex(of: userToBlockID) {
                    friendsList?.remove(at: index)
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
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))

                } else {
                    Image("UserIcon") // Your user's profile picture
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                }
                Text(userB?.username ?? "friend")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                
                Button(action: {
                    showAlert = true
                }) {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 40)
                }
                .actionSheet(isPresented: $showAlert) {
                    ActionSheet(
                        title: Text("Friend Actions"),
                        message: nil,
                        buttons: [
                            .destructive(Text("Remove Friend")) {
                                removeFriend()
                            },
                            .default(Text("Block User")) {
                                blockUser()
                                removeFriend()
                            },
                            .cancel()
                        ]
                    )
                }
                Spacer()
            }
            .padding(.leading, 40)
        }
        .onAppear {
            loadUser {
                print("")
            }
        }
    }
}


struct RequestSentDisplay: View {
    @State var userB : User?
    @State var userBID: String?
    @StateObject var imageLoader = ImageLoader()

    func loadUser(completion: @escaping () -> Void) {
        
        let docRef = Firestore.firestore().collection("users").document(userBID ?? "")
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                do {
                    userB = try document.data(as: User.self)
                    print("User successfully fetched")
                    
                    if let imageUrl = userB?.name {
                        let storageRef = Storage.storage().reference()
                        storageRef.child(imageUrl).downloadURL { url, error in
                            if let url = url {
                                // Load image using image loader
                                imageLoader.loadImage(from: url)
                            } else if let error = error {
                                print("Error downloading image: \(error.localizedDescription)")
                            }
                            completion() // Call completion handler after fetching image
                        }
                    } else {
                        completion() // Call completion handler if image URL is nil
                    }
                } catch {
                    print("Error decoding user document: \(error.localizedDescription)")
                    completion()
                }
            } else {
                print("User document does not exist")
                completion()
            }
        }
    }
    
    func retractRequest(completion: @escaping () -> Void) {
        var userA = UserDefaults.standard.string(forKey: "uid") ?? "uid"
        var userB = userB?.uid ?? "uid"
        
        let db = Firestore.firestore()
        
        let senderRef = db.collection("users").document(userA)
        senderRef.updateData([
            "friendRequestsSent": FieldValue.arrayRemove([userB])
        ]) { error in
            if let error = error {
                print("Error removing friend request sent by \(userA): \(error.localizedDescription)")
                return
            }
            print("Friend request removed from sender's document")
        }
        let receiverRef = db.collection("users").document(userB)
        receiverRef.updateData([
            "friendRequestsReceived": FieldValue.arrayRemove([userA])
        ]) { error in
            if let error = error {
                print("Error removing friend request sent by \(userB): \(error.localizedDescription)")
                return
            }
            print("Friend request removed from receiver's document")
        }
        
        
        
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(hex: "E1DDED"))
                .frame(width: UIScreen.main.bounds.width - 40, height: 60)
            HStack {
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))

                } else {
                    Image("UserIcon") // Your user's profile picture
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                }
                Text(userB?.username ?? "")
                    .foregroundColor(.black)
                    .font(.system( size: 15))
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    retractRequest {
                        print("successful retraction")
                    }
                }) {
                    Image(systemName: "multiply")
                        .foregroundColor(Color.gray)
                        .frame(width: 30, height: 30)
                }
                
            }.padding(.horizontal, 40)
            
        }
        .onAppear {
            loadUser {
                print("")
            }
        }
    }
}
struct RequestReceivedDisplay: View {
    @State var userB : User?
    @State var userBID : String?
    @StateObject var imageLoader = ImageLoader()
    
    func loadUser(completion: @escaping () -> Void) {
        
        let docRef = Firestore.firestore().collection("users").document(userBID ?? "")
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                do {
                    userB = try document.data(as: User.self)
                    print("User successfully fetched")
                    if let imageUrl = userB?.name {
                        let storageRef = Storage.storage().reference()
                        storageRef.child(imageUrl).downloadURL { url, error in
                            if let url = url {
                                // Load image using image loader
                                imageLoader.loadImage(from: url)
                            } else if let error = error {
                                print("Error downloading image: \(error.localizedDescription)")
                            }
                            completion() // Call completion handler after fetching image
                        }
                    } else {
                        completion() // Call completion handler if image URL is nil
                    }
                    
                    
                } catch {
                    print("Error decoding user document: \(error.localizedDescription)")
                    completion()
                }
            } else {
                print("User document does not exist")
                completion()
            }
        }
    }
    
    func acceptRequest(completion: @escaping () -> Void) {
        var userA = UserDefaults.standard.string(forKey: "uid") ?? "uid"
        var userB = userB?.uid ?? "uid"
        
        let db = Firestore.firestore()
        
        let senderRef = db.collection("users").document(userA)
        senderRef.updateData([
            "friendRequestsReceived": FieldValue.arrayRemove([userB])
        ]) { error in
            if let error = error {
                print("Error removing friend request sent by \(userA): \(error.localizedDescription)")
                return
            }
            print("Friend request removed from sender's document")
        }
        senderRef.updateData([
            "friends": FieldValue.arrayUnion([userB])
        ]) { error in
            if let error = error {
                print("Error updating user document's friend: \(error)")
            } else {
                print("User document updated with friend successfully!")
            }
        }
        let receiverRef = db.collection("users").document(userB)
        receiverRef.updateData([
            "friendRequestsSent": FieldValue.arrayRemove([userA])
        ]) { error in
            if let error = error {
                print("Error removing friend request received by \(userB): \(error.localizedDescription)")
                return
            }
            print("Friend request removed from receiver's document")
        }
        receiverRef.updateData([
            "friends": FieldValue.arrayUnion([userA])
        ]) { error in
            if let error = error {
                print("Error updating user document's friend: \(error)")
            } else {
                print("User document updated with friend successfully!")
            }
        }
    }
    
    func rejectRequest(completion: @escaping () -> Void) {
        var userA = UserDefaults.standard.string(forKey: "uid") ?? "uid"
        var userB = userB?.uid ?? "uid"
        
        let db = Firestore.firestore()
        
        let senderRef = db.collection("users").document(userA)
        senderRef.updateData([
            "friendRequestsReceived": FieldValue.arrayRemove([userB])
        ]) { error in
            if let error = error {
                print("Error removing friend request sent by \(userA): \(error.localizedDescription)")
                return
            }
            print("Friend request removed from sender's document")
        }
    }
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(hex: "E1DDED"))
                .frame(width: UIScreen.main.bounds.width - 40, height: 60)
            HStack {
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))

                } else {
                    Image("UserIcon") // Your user's profile picture
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                }

                Text(userB?.username ?? "")
                    .foregroundColor(.black)
                    .font(.system( size: 15))
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    acceptRequest {
                        print("acceptRequesthit")
                    }
                }) {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color(hex: "9278E0"))
                        .frame(width: 30, height: 30)
                }
                Button(action: {
                    rejectRequest {
                        print("rejectRequesthit")
                    }
                }) {
                    Image(systemName: "multiply")
                        .foregroundColor(Color.gray)
                        .frame(width: 30, height: 30)
                }
                
                
            }.padding(.horizontal, 40)
            
        }
        .onAppear {
            loadUser {
                print("")
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
