//
//  Profile.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 2/16/24.
//

import Foundation
import SwiftUI
import UIKit
import Firebase

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var userUsername = ""
    
    func signOut() throws {
        try AuthManager.shared.signout()
    }
    
    func GetAuthenticatedUser() throws -> AuthDataResultModel {
        let user = try AuthManager.shared.getAuthenticatedUser()
        return user
    }
    
    func GetUsername() async {
        var nameU = ""
        
        do {
            let user = try GetAuthenticatedUser();
            let db = Firestore.firestore()
            let userId = user.uid
            let docRef = db.collection("users").document(userId)
            let document = try await docRef.getDocument()
            let data = document.data()
            userUsername = data?["username"] as? String ?? ""
            //userUsername = nameU
            print(nameU)
            
        } catch {
            
        }
    }
}

struct ProfileSummary: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var isAuthenticated: Bool
    var email = UserDefaults.standard.string(forKey: "email") ?? "atharva.gu@gmail.com"
    var name = UserDefaults.standard.string(forKey: "username") ?? "name here"
    var phoneNumber = "(510) 335-9060"
    var uid = UserDefaults.standard.string(forKey: "uid") ?? "uid"
    var body: some View {
        NavigationView {
            VStack {
                Image("UserIcon") // Your user's profile picture
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .padding(.top, 30)
                Text(name)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .padding(.top, 5)
                VStack {
                    HStack {
                        Text("Email: ") // Display the user's email
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                        Spacer()
                        Text(email)
                    }
                    HStack {
                        Text("Phone number: ") // Display the user's email
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                        Spacer()
                        Text(phoneNumber)
                    }
                }
                .padding(.bottom, 45)
                .padding(.top, 25)
                // Action Buttons
                VStack(spacing: 15) {
                    NavigationLink(destination: ChangePasswordUI()) {
                        Label("Change Password", systemImage: "lock.rotation")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .frame(height:50)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: .uIpurple.opacity(0.3), radius: 5, x: 0, y: 0)
                        .padding(.bottom, 15)
                    }
                    
                    NavigationLink(destination: DeleteAccountUI()) {
                        Label("Delete Account", systemImage: "trash")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .frame(height:50)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .background(Color(hex: "CBC3E3"))
                        .cornerRadius(10)
                        .shadow(color: .uIpurple.opacity(0.3), radius: 5, x: 0, y: 0)
                        .padding(.bottom, 15)
                    }
                    
                    NavigationLink(destination: ChangeUsernameUI()) {
                        Label("Change Username", systemImage: "trash")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .frame(height:50)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .background(Color(hex: "CBC3E3"))
                        .cornerRadius(10)
                        .shadow(color: .uIpurple.opacity(0.3), radius: 5, x: 0, y: 0)
                        .padding(.bottom, 15)
                    }

                    
                    Button(action: {
                        // Handle log out
                        do {
                            try viewModel.signOut()
                            isAuthenticated = false
                        } catch {
                            print("Error signing out: \(error.localizedDescription)")
                        }
                        print("Log out")
                    }) {
                        Label("Log Out", systemImage: "arrow.backward.circle")
                    }
                    .buttonStyle(ProfileButtonStyle())
                    .padding(.horizontal)
                    .background(Color.black)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 0)
                    .padding(.bottom, 15)
                }
                .padding()
                
                Spacer() // Pushes everything to the top
            }
            .padding()
            .navigationBarHidden(true)
            .background(Color("Background").edgesIgnoringSafeArea(.all)) // Assuming you have a color set named "Background"
        }
    }
}

// Custom button style for profile view
struct ProfileButtonStyle: ButtonStyle {
    var foregroundColor: Color = .white
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foregroundColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("ButtonBackground").cornerRadius(10))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}


struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = false
        ProfileSummary(isAuthenticated:$isAuthenticated)
    }
}
