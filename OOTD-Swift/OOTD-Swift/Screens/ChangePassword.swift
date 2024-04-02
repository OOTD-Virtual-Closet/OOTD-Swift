//
//  ChangePassword.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 3/2/24.
//


import SwiftUI
import Firebase
import FirebaseAuth


enum ChangePasswordErrors: Error{
    case invalidNewPass
    case incorrectOldPass
    case notMatching
}

@MainActor
final class ProfileViewModelChangePassword: ObservableObject {
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    func ChangePass(newPassFirst: String, newPass: String) async throws {
        guard isValidPassword(password: newPass) else {
            throw ChangePasswordErrors.invalidNewPass;
        }
        
        guard passwordsMatching(pass1: newPassFirst, pass2: newPass) else {
            throw ChangePasswordErrors.notMatching;
        }
        
        /*
        guard isCorrectOldPass(oldPass: oldPass) else {
            print("incorrect old pass")
            throw ChangePasswordErrors.incorrectOldPass;
        }
         */
        
        do {
            let user = try getAuthenticatedUser()
            let db = Firestore.firestore()
            let userId = user.uid
            try AuthManager.shared.changePassword(password: newPass)
            SignUpViewModel().passwordEntered = newPass
            try await db.collection("users").document(userId).setData(["password" : newPass], merge:true)
        } catch {}
    
    }
    
    private func passwordsMatching (pass1: String, pass2: String) -> Bool {
        return pass1 == pass2
    }
    
    private func isValidPassword(password: String) -> Bool {
        // checks if the password that is passed is a valid password
        // minimum 6 characters long
        // 1 uppercase character
        // 1 special character
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
    
    
    private func isCorrectOldPass(oldPass: String) -> Bool {
        let currPass = SignUpViewModel().passwordEntered
        print("currPass " + currPass)
        return currPass == oldPass
    }
    
}

struct ChangePasswordUI: View {
    @StateObject private var viewModel = ProfileViewModelChangePassword()
    @State private var newPass: String = ""
    @State private var newPassConfirm: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    HStack {
                        Text("Change Password!")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color(hex:"CBC3E3"))
                    }
                    .padding()
                    .padding()
                    
                    VStack {
                        HStack {
                            TextField("New Password...", text: $newPass)
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
                            TextField("Confirm Password...", text: $newPassConfirm)
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
                        
                        NavigationLink(destination: WelcomePage3()) {
                             //TODO: REDIRECT TO FORGOT PASSWORD ONCE CREATED
                            
                            Text("Forgot Password?")
                                .foregroundStyle(Color(hex: "CBC3E3"))
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                                .padding(.bottom, 30)
                        }
                        .padding(.horizontal)
                        
                    }
                    
                    VStack {
                        @State var isAuthenticated = false
                        NavigationLink(destination: ProfileSummary(isAuthenticated:$isAuthenticated)) {
                            Text("BACK")
                            .frame(maxWidth: .infinity)
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
                                    //checks errors on if the password is correct or not
                                    try await viewModel.ChangePass(newPassFirst: newPass, newPass: newPassConfirm)
                                    showingAlert = true
                                    alertMessage = "Password changed!"
                                } catch ChangePasswordErrors.invalidNewPass {
                                    print("Invalid Password")
                                    showingAlert = true
                                    alertMessage = "Invalid Password. Password must be minimum 6 characters long and must contain a capital letter and a special character"
                                } catch ChangePasswordErrors.incorrectOldPass {
                                    print("incorrect old pass")
                                    showingAlert = true
                                    alertMessage = "The old password you entered is incorrect."
                                } catch ChangePasswordErrors.notMatching {
                                    showingAlert = true
                                    alertMessage = "The two passwords do not match."
                                }
                            }
                        } label: {
                            HStack {
                                    Text("CHANGE PASSWORD")
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
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Change Password Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}


struct Change_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordUI()
    }
}
