//
//  DeleteAccount.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 2/16/24.

import SwiftUI
import FirebaseAuth
import Firebase

enum deleteAccountErrors: Error{
    case notMatching
    case incorrectEmail
}


@MainActor
final class ProfileViewModelConfirm: ObservableObject {
    func verifyDelete() throws {
        try AuthManager.shared.verifyDelete()
    }
}

@MainActor
final class ProfileViewModelDeleteAcc: ObservableObject {
    func GetAuthenticatedUser() throws -> AuthDataResultModel {
        let user = try AuthManager.shared.getAuthenticatedUser()
        return user
    }
    
   

    func deleteAcc(emailP1: String, emailP2: String) async throws {
        
        guard emailsMatching(email1: emailP1, email2: emailP2) else {
            print("emails are not matching")
            throw deleteAccountErrors.notMatching
        }
        guard checkCorrectEmail(email: emailP1) else {
            print("used wrong email")
            throw deleteAccountErrors.incorrectEmail
        }

    }
    
    private func emailsMatching (email1: String, email2: String) -> Bool {
        return email1 == email2
    }
    
    private func checkCorrectEmail (email: String) -> Bool {
        do {
            let result = try GetAuthenticatedUser().email == email
            return result
        } catch {
            print("couldnt get user")
            return false
        }
    }
}

struct ConfirmDelete: View {
    @StateObject private var viewModel = ProfileViewModelConfirm()
    var body: some View {
        ZStack {
            VStack {
                Text("are you sure?")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color(hex:"CBC3E3"))
                
                NavigationLink(destination: DeleteAccountUI()) {
                    Text("NO, BACK")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .frame(height:50)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .background(Color("UIpurple"))
                        .cornerRadius(10)
                        
                }
                
                Button {
                    Task {
                        try viewModel.verifyDelete()
                    }
                } label: {
                    HStack {
                        Text("YES, DELETE")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .frame(height:50)
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .background(Color("UIpurple"))
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct DeleteAccountUI: View {
    @StateObject private var viewModel = ProfileViewModelDeleteAcc()
    @State private var email1: String = ""
    @State private var confirmEmail: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    HStack {
                        Text("Delete Current Account!")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color(hex:"CBC3E3"))
                    }
                    .padding()
                    .padding()
                    VStack {
                        Text("⚠️ Warning: This cant be undone! All changes are permanent! ⚠️")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundStyle(Color(hex:"898989"))
                            .font(.title3)
                            .fontWeight(.heavy)
                        
                        Text("Make sure to enter the email adress of the current account")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundStyle(Color(hex:"898989"))
                            .fontWeight(.heavy)
                    }
                    
                    VStack {
                        HStack {
                            TextField("Email...", text: $email1)
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
                            TextField("Confirm Email...", text: $confirmEmail)
                            
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
                        @State var isAuthenticated = false
                        NavigationLink(destination: Signup(isAuthenticated: $isAuthenticated)
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
                                    try await viewModel.deleteAcc(emailP1:email1, emailP2:confirmEmail)
                                    isAuthenticated = true
                                    
                                } catch deleteAccountErrors.notMatching {
                                    showingAlert = true
                                    alertMessage = "The two emails do not match"
                                } catch deleteAccountErrors.incorrectEmail {
                                    showingAlert = true
                                    alertMessage = "The email entered is not associated with this account"
                                }
                            }
                        } label: {
                            HStack {
                                Text("DELETE")
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .frame(height:50)
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .background(Color("UIpurple"))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
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


struct Delete_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmDelete()
    }
}
