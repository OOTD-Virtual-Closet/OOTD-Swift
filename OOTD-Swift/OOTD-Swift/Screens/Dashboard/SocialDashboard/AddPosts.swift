//
//  AddPosts.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/17/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

import UIKit



struct AddPosts: View {
    @Environment(\.presentationMode) var presentationMode


    @State private var isEditing = false


    @State private var name : String?
    @State var selectedImage: UIImage?

    @State private var searchText = ""
    
    
    @State var showAlert = false
    @State var alertMessage = "Please fill out all fields"
    
    func getImageForSelectedType() -> UIImage? {
            let randomVal = Int.random(in: 1...11)
            switch randomVal {
            case 1:
                let uiImage = UIImage(named: "postsample1")
                return uiImage
            case 2:
                let uiImage = UIImage(named: "postsample2")
                return uiImage
            case 3:
                let uiImage = UIImage(named: "postsample3")
                return uiImage
            case 4:
                let uiImage = UIImage(named: "postsample4")
                return uiImage
            case 5:
                let uiImage = UIImage(named: "postsample5")
                return uiImage
            case 6:
                let uiImage = UIImage(named: "postsample6")
                return uiImage
            case 7:
                let uiImage = UIImage(named: "postsample7")
                return uiImage
            case 8:
                let uiImage = UIImage(named: "postsample8")
                return uiImage
            case 9:
                let uiImage = UIImage(named: "postsample9")
                return uiImage
            default:
                let uiImage = UIImage(named: "postsample10")
                return uiImage
            }
        }
    

    func uploadPostImage() -> String {
        guard let selectedImage = selectedImage else {
                print("No image selected")
                return ""
            }

            //create storage reference
            let storageRef = Storage.storage().reference()
            
            // turn image into data
            guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
                print("Failed to convert image to data")
                return ""
            }
            
            // specify filepath and name
            let path = "posts/\(UUID().uuidString).jpg"
            let fileRef = storageRef.child(path)
            
            // Upload the data
            let uploadTask = fileRef.putData(imageData, metadata: nil) { metadata, error in
                if error == nil {
                    print("Successfully stored image at \(path)")
                } else {
                    print("Failed storing image:", error?.localizedDescription ?? "")
                }
            }
            return path
       
    }

    var body: some View {
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false){
                    VStack {
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(height: UIScreen.main.bounds.height / 7)
                            .ignoresSafeArea(.all)
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(hex: "E1DDED"))
                            .frame(width: UIScreen.main.bounds.width - 60, height: 330)
                            .padding(.bottom, 20)
                           .overlay(
                            Text("Take Picture!")
                                .foregroundColor(.black)
                                .font(.system( size: 20))
                           )
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .foregroundColor(Color(hex: "9278E0"))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .padding(.bottom, 20)
                        VStack (alignment: .leading, spacing: 10){
                            Text("Caption")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .font(.system( size: 18))
                                .padding(.leading, 5)
                            ZStack {
                                        TextField("", text: $searchText, onEditingChanged: { editing in
                                            isEditing = editing
                                        }).onChange(of: searchText) { newValue in
                                            if newValue.count > 20 {
                                                searchText = String(newValue.prefix(20))
                                            }
                                        }

                                        .frame(width: UIScreen.main.bounds.width - 90, height: 40)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color(hex: "E1DDED"))
                                                .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                                                .shadow(radius: 4)
                                        )
                                        .overlay(
                                            HStack {
                                                Text("Name...")
                                                    .foregroundColor(.black)
                                                Spacer()
                                            }
                                            .opacity(isEditing || !searchText.isEmpty ? 0 : 1)
                                        )
                            }
                            .padding(.horizontal,25)
                                .padding(.vertical, 10)
                            
                            
                            Rectangle()
                                .foregroundColor(Color.white)
                                .frame(height: 200)
                                .ignoresSafeArea(.all)
                        }
                        .padding(.horizontal)
                    }
                }
                Rectangle()
                    .foregroundColor(Color(hex: "9278E0"))
                    .frame(height: UIScreen.main.bounds.height / 8)
                    .ignoresSafeArea(.all)
                HStack {
                    Button(action: {
                        selectedImage = getImageForSelectedType()
                        let path = uploadPostImage()
                        
                        if searchText == "" {
                            showAlert = true
                        }
                         else if path == "" {
                            showAlert = true
                             alertMessage = "Photo upload failed"
                         } else {
                             let post = Post(owner:  UserDefaults.standard.string(forKey: "uid") ?? "uid", caption: searchText  ,image: path)
                             
                             let postViewModel = PostViewModel()
                             postViewModel.addPostToCurrentUser(post: post)
                             presentationMode.wrappedValue.dismiss()
                         }
                        
                    }) {
                        Text("Add")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.leading, 15)
                            .font(.system(size: 12))
                    }
                    Spacer()
                    Text("New Item")
                        .foregroundColor(.white)
                        .font(.system( size: 20))
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Text("Cancel")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding(.trailing, 15)
                                        .font(.system( size: 12))
                                }
                }.padding(.top, 20)
                
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
}


struct AddPostsView_Preview: PreviewProvider {
    static var previews: some View {
        AddPosts()
    }
}
