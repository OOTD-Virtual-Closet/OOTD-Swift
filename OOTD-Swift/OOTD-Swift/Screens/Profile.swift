//
//  Profile.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 2/16/24.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseFirestore


@MainActor
final class ProfileViewModel: ObservableObject {
    func signOut() throws {
        try AuthManager.shared.signout()
    }
    
    func deleteAccount() async throws {
        try await AuthManager.shared.deleteAccount()
    }
}

struct ProfileSummary: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var isAuthenticated: Bool
    @AppStorage("staySignedIn") private var staySignedIn: Bool = UserDefaults.standard.bool(forKey: "staySignedIn")
    
    var email = UserDefaults.standard.string(forKey: "email") ?? "atharva.gu@gmail.com"
    var name = "Atharva Gupta"
    var phoneNumber = "(510) 335-9060"
    @State var pinnedOne : String?
    @State var pinnedTwo : String?
    @State var pinnedThree : String?
    @State var index = 0
    var uid = UserDefaults.standard.string(forKey: "uid") ?? "uid"
    
    func populatePinnedOutfits(completion: @escaping (Error?) -> Void) {
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        userRef.getDocument { document, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let document = document else {
                let error = NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document not found"])
                completion(error)
                return
            }
            
            let pinnedFits = document.data()?["pinnedFits"] as? [String] ?? []
            
            // Populate state variables pinnedone, pinnedtwo, and pinnedthree
            pinnedOne = pinnedFits.indices.contains(0) ? pinnedFits[0] : nil
            pinnedTwo = pinnedFits.indices.contains(1) ? pinnedFits[1] : nil
            pinnedThree = pinnedFits.indices.contains(2) ? pinnedFits[2] : nil
            
            completion(nil)
        }
    }
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
                       
                            NavigationLink(destination: ProfilePinnedOutfits(index: 0)) {
                                
                                    if pinnedOne != nil && pinnedOne != "" {
                                        OutfitsPinned(item: pinnedOne!)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 70, height: 70)
                                            .clipShape(Circle())
                                    } else {
                                        Circle()
                                            .foregroundColor(Color(hex: "9278E0"))
                                            .frame(width: 70, height: 70)
                                            .overlay(
                                                Image(systemName: "plus")
                                                    .foregroundColor(.white)
                                            )
                                    }
                            }
                        
                        
                        
                            NavigationLink(destination: ProfilePinnedOutfits(index: 1)) {
                                
                                    if pinnedTwo != nil && pinnedTwo != "" {
                                        OutfitsPinned(item: pinnedTwo!)
                                            .scaledToFit()
                                            .frame(width: 70, height: 70)
                                            .clipShape(Circle())
                                    } else {
                                        Circle()
                                            .foregroundColor(Color(hex: "9278E0"))
                                            .frame(width: 70, height: 70)
                                            .overlay(
                                                Image(systemName: "plus")
                                                    .foregroundColor(.white)
                                            )
                                    }
   
                            }
                        
                        
                            NavigationLink(destination: ProfilePinnedOutfits(index: 2)) {
                               
                                    if pinnedThree != nil  && pinnedThree != "" {
                                        OutfitsPinned(item: pinnedThree!)
                                            .frame(width: 70, height: 70)
                                            .clipShape(Circle())
                                    } else {
                                        Circle()
                                            .foregroundColor(Color(hex: "9278E0"))
                                            .frame(width: 70, height: 70)
                                            .overlay(
                                                Image(systemName: "plus")
                                                    .foregroundColor(.white)
                                            )
                                    }
                        }
                    }

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
                        Text("Quick Login: ")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                        Spacer()
                        Toggle("", isOn: $staySignedIn)
                    }
                }
                .padding(.bottom, 45)
                .padding(.top, 25)
                // Action Buttons
                VStack(spacing: 15) {
                    
                    Button(action: {
                        // Handle change password
                        print("change password pressed")
                    }) {
                        Label("Change Password", systemImage: "lock.rotation")
                    }
                    .buttonStyle(ProfileButtonStyle())
                    .padding(.horizontal)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 0)
                    .padding(.bottom, 15)
                    
                    Button(action: {
                        // Handle account deletion
                        Task {
                            do {
                               try await viewModel.deleteAccount()
                               isAuthenticated = false
                           } catch {
                               print("Error deleting account: \(error.localizedDescription)")
                           }
                        }
//                        print("Delete Account");
                    }) {
                        Label("Delete Account", systemImage: "trash")
                    }
                    .buttonStyle(ProfileButtonStyle())
                    .buttonStyle(ProfileButtonStyle())
                    .padding(.horizontal)
                    .background(Color(hex: "CBC3E3"))
                    .cornerRadius(10)
                    .shadow(color: .uIpurple.opacity(0.3), radius: 5, x: 0, y: 0)
                    .padding(.bottom, 15)
                    
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
            .background(Color("Background").edgesIgnoringSafeArea(.all)) // Assuming you have a color set named "Background"
        
            .onAppear {
                populatePinnedOutfits { error in
                                   if let error = error {
                                       print("Error populating pinned outfits: \(error.localizedDescription)")
                                   } else {
                                       print("Pinned outfits populated successfully")
                                   }
                               }
            }
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
