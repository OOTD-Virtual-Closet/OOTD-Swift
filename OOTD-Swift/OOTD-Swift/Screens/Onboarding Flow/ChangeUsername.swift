//
//  ChangeUsername.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 3/24/24.
//

//
//  DeleteAccount.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 2/16/24.

import SwiftUI
import FirebaseAuth
import Firebase

enum changeUsernameErrors: Error{
    case notMatching
    case invalidUsername
}

@MainActor
final class ProfileViewModelChangeUser: ObservableObject {
    func GetAuthenticatedUser() throws -> AuthDataResultModel {
        let user = try AuthManager.shared.getAuthenticatedUser()
        return user
    }

    func changeUser(user1: String, user2: String) async throws {
        guard usersMatching(user1: user1, user2: user2) else {
            print("usernames are not matching")
            throw changeUsernameErrors.notMatching
        }
        
        guard isValidUsername(username: user1) else {
            print("invalid username")
            throw changeUsernameErrors.invalidUsername
        }
        
        do {
            let user = try GetAuthenticatedUser()
            let db = Firestore.firestore()
            let userId = user.uid
            try await db.collection("users").document(userId).setData(["username" : user2], merge:true)
            print(userId)
        } catch {
            
        }

    }
    
    private func usersMatching (user1: String, user2: String) -> Bool {
        return user1 == user2
    }
    
    private func isValidUsername (username: String) -> Bool {
        let strlen = username.utf8.count;
        if (strlen >= 15) {
            return false;
        }
        return true;
    }
}


struct ChangeUsernameUI: View {
    @StateObject private var viewModel = ProfileViewModelChangeUser()
    @State private var username: String = ""
    @State private var confirmUsername: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    HStack {
                        Text("Change Username!")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color(hex:"CBC3E3"))
                    }
                    .padding()
                    .padding()
                    
                    VStack {
                        HStack {
                            TextField("New Username...", text: $username)
                            Image(systemName: "checkmark")
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2.0)
                                .foregroundColor(Color(hex:"898989"))
                        )
                        .padding()
                        
                        HStack {
                            TextField("Confirm Username...", text: $confirmUsername)
                            
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2.0)
                                .foregroundColor(Color(hex:"898989"))
                        )
                        .padding()
                    }
                    
                    VStack {
                        @State var isAuthenticated = true
                        
                        NavigationLink(destination: ProfileSummary(isAuthenticated:$isAuthenticated)
                            .environmentObject(LogInVM())) {
                            Text("BACK")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .frame(height:50)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .background(Color("UIpurple"))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        Button {
                            Task {
                                do {
                                    try await viewModel.changeUser(user1:username, user2:confirmUsername)
                                    isAuthenticated = true
                                    
                                } catch changeUsernameErrors.notMatching {
                                    showingAlert = true
                                    alertMessage = "The two usernames do not match"
                                } catch changeUsernameErrors.invalidUsername {
                                    showingAlert = true
                                    alertMessage = "There should be less than 15 characters in the username"
                                }
                            }
                        } label: {
                            HStack {
                                Text("Change Username")
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .frame(height:50)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .background(Color("UIpurple"))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        .background(NavigationLink(destination: Login(isAuthenticated: $isAuthenticated)
                            .environmentObject(LogInVM())) { EmptyView() }.hidden())
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(LogInVM())
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                        
                    }
                    Spacer()
                }
            }
        }
    }
}


struct Username_Previews: PreviewProvider {
    static var previews: some View {
        ChangeUsernameUI()
    }
}
