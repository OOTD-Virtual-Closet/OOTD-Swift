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
        var fetchedPosts: [Post] = []
        let dispatchGroup = DispatchGroup()
        
        // Fetch posts from friends
        fetchPostsFromFriendsList(db: db, dispatchGroup: dispatchGroup) { postsFromFriends in
            fetchedPosts.append(contentsOf: postsFromFriends)
        }
        
        // Fetch posts from the initial user document (the one with uid variable)
        dispatchGroup.enter()
        let currentUserUID = uid
        let currentUserRef = db.collection("users").document(currentUserUID)
        currentUserRef.getDocument { document, error in
            defer {
                dispatchGroup.leave()
            }
            
            if let error = error {
                print("Error fetching current user document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Current user document not found")
                return
            }
            
            if let posts = document.data()?["postsId"] as? [String] {
                for postID in posts {
                    let postRef = db.collection("posts").document(postID)
                    dispatchGroup.enter()
                    postRef.getDocument { postDocument, error in
                        defer {
                            dispatchGroup.leave()
                        }
                        
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
            } else {
                print("Posts not found in current user document")
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(fetchedPosts)
        }
    }
    
    private func fetchPostsFromFriendsList(db: Firestore, dispatchGroup: DispatchGroup, completion: @escaping ([Post]) -> Void) {
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
                for friendUID in friends {
                    let friendRef = db.collection("users").document(friendUID)
                    dispatchGroup.enter()
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
                        
                        if let posts = friendDocument.data()?["postsId"] as? [String] {
                            for postID in posts {
                                let postRef = db.collection("posts").document(postID)
                                dispatchGroup.enter()
                                postRef.getDocument { postDocument, error in
                                    defer {
                                        dispatchGroup.leave()
                                    }
                                    
                                    if let error = error {
                                        print("Error fetching post document for \(postID): \(error.localizedDescription)")
                                        return
                                    }
                                    
                                    guard let postDocument = postDocument, postDocument.exists else {
                                        print("Post document not found for \(postID)")
                                        return
                                    }
                                    
                                    if let post = try? postDocument.data(as: Post.self) {
                                        completion([post])
                                    } else {
                                        print("Failed to decode post document for \(postID)")
                                    }
                                }
                            }
                        } else {
                            print("Posts not found in friend document for \(friendUID)")
                        }
                    }
                }
            } else {
                print("Friends not found in current user document")
            }
        }
    }
    
    
    
    
    var body: some View {
        ScrollView {
//            ZStack {
//                TextField("", text: $searchText, onEditingChanged: { editing in
//                    isEditing = editing
//                })
//                .padding(.leading, 30)
//                .frame(width: UIScreen.main.bounds.width - 90, height: 40)
//                .background(
//                    RoundedRectangle(cornerRadius: 10)
//                        .foregroundColor(Color(hex: "F4F4F4"))
//                        .padding(.leading, 15)
//                )
//                .overlay(
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//                            .resizable()
//                            .foregroundColor(.black)
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 20, height: 20)
//                            .padding(.leading, 27)
//                        Text("Search...")
//                            .foregroundColor(.black)
//                            .font(.system(size: 17))
//                            .fontWeight(.heavy)
//                            .padding(.leading, 5)
//                        Spacer()
//                    }
//                        .opacity(isEditing || !searchText.isEmpty ? 0 : 1)
//                )
//            }
            VStack(spacing: 20) {
                ForEach(feed ?? [], id: \.self) { test in
                    PostView(item: test.id, UserID: test.owner )
                }
            }
            .onAppear {
                fetchPostsFromFriends { fetchedPosts in
                    // Update the posts array with fetched posts
                    self.feed = fetchedPosts
                }
            }
            
            .padding (.top, 50)
        }
    }
    
}
