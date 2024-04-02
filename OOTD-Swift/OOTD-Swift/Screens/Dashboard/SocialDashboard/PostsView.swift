//
//  PostsView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
struct PostsView: View {
    var uid = UserDefaults.standard.string(forKey: "uid") ?? "uid"
    @State var addPostPresented = false
    @State private var userposts : [Post]?

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                        VStack(spacing: 20) {
                            ForEach(userposts ?? [], id: \.self) { onepost in
                                PostView(item: onepost.id, UserID: uid)
                            }
                        }
                       
                    }
            .padding (.top, 50)
            Button(action: {
                           addPostPresented.toggle()
                       }) {
                           HStack {
                               Spacer()
                               Image(systemName: "plus")
                                   .font(.title)
                                   .foregroundColor(.black)
                                   .frame(width: 50, height: 50)
                                   .background(Color(hex: "E1DDED"))
                                   .clipShape(Circle())
                                   .overlay(Circle()
                                            .stroke(Color.black,
                                                    lineWidth: 2)
                                    )
                                   .padding(.trailing, 20)
                           }
                       }
                       .padding(.bottom, 50)
        }
        .sheet(isPresented: $addPostPresented, onDismiss: {
            populateArrays {
                print("posts arrays are updated in PostsView")
            }
        }) {
                AddPosts()
            }
        .onAppear {
            populateArrays{
                print("posts arrays updated in PostsView")
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
                        userposts = loadedPosts
                        completion()
                    }
                }
            } else {
                print("User document does not exist")
            }
        }
    }

}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
