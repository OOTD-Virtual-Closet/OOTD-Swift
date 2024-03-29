//
//  FeedView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct FeedView: View {
    @State private var searchText = ""
    var uid = UserDefaults.standard.string(forKey: "uid") ?? "uid"
    @State private var isEditing = false
    @State private var feed : [Post]?

    private func fetchPostsFromFriends(completion: @escaping ([Post]) -> Void) {
        let db = Firestore.firestore()
        
        // Fetch the current user's document
        let currentUserUID = uid
        let currentUserRef = db.collection("users").document(currentUserUID)
        currentUserRef.getDocument { document, error in
            if let error = error {
                print("Error fetching current user document: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let document = document, document.exists else {
                print("Current user document not found")
                completion([])
                return
            }
            
            // Extract the "friends" array from the current user's document
            if let friends = document.data()?["friends"] as? [String] {
                var fetchedPosts: [Post] = []
                let dispatchGroup = DispatchGroup()
                
                // For each friend, fetch their document and extract posts
                for friendUID in friends {
                    dispatchGroup.enter()
                    let friendRef = db.collection("users").document(friendUID)
                    friendRef.getDocument { friendDocument, error in
                        defer {
                            dispatchGroup.leave()
                        }
                        
                        if let error = error {
                            print("Error fetching friend document for \(friendUID): \(error.localizedDescription)")
                            return
                        }
                        
                        guard let friendDocument = friendDocument, friendDocument.exists else {
                            print("Friend document not found for \(friendUID)")
                            return
                        }
                        
                        if let posts = friendDocument.data()?["posts"] as? [String] {
                            do {
                                for postID in posts {
                                    let postRef = db.collection("postsId").document(postID)
                                    postRef.getDocument { postDocument, error in
                                        if let error = error {
                                            print("Error fetching post document for \(postID): \(error.localizedDescription)")
                                            return
                                        }
                                        
                                        guard let postDocument = postDocument, postDocument.exists else {
                                            print("Post document not found for \(postID)")
                                            return
                                        }
                                        
                                        if let post = try? postDocument.data(as: Post.self) {
                                            fetchedPosts.append(post)
                                        } else {
                                            print("Failed to decode post document for \(postID)")
                                        }
                                    }
                                }
                            }
                        } else {
                            print("Posts not found in friend document for \(friendUID)")
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(fetchedPosts)
                }
            } else {
                print("Friends not found in current user document")
                completion([])
            }
        }
    }
    
    private func populateArrays(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let posts = document.data()?["postsId"] as? [String] {
                    var loadedPosts = [Post]()
                    let dispatchGroup = DispatchGroup()
                    
                    for item in posts {
                        dispatchGroup.enter()
                        
                        let docRef = db.collection("posts").document(item)
                        docRef.getDocument { document, error in
                            defer {
                                dispatchGroup.leave()
                            }
                            if let document = document, document.exists {
                                do {
                                    let testPost =  try document.data(as: Post.self)
                                        loadedPosts.append(testPost)
                                    
                                } catch {
                                    print("Error decoding post document: \(error.localizedDescription)")
                                }
                            } else {
                                print("post document does not exist")
                            }
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        feed = loadedPosts
                        completion()
                    }
                }
            } else {
                print("User document does not exist")
            }
        }
    }

    var body: some View {
        ScrollView {
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
                        ForEach(0..<10) { _ in
                           // PostView()
                        }
                    }
                }
        .onAppear {
                  fetchPostsFromFriends { posts in
                      self.feed = posts
                  }
            populateArrays{
                print("tess")
            }
              }
        .padding (.top, 50)
    }
}





//struct FeedView_Previews: PreviewProvider {
  //  static var previews: some View {
       // FeedView()
  //  }
//}
