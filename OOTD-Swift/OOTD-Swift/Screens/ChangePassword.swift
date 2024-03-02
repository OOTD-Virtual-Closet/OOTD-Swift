//
//  ChangePassword.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 3/2/24.
//


import SwiftUI


enum ChangePasswordtErrors: Error{
    case invalidNewPass
}

@MainActor
final class ProfileViewModelChangePassword: ObservableObject {
    func ChangePassword(password:String) throws {
        try AuthManager.shared.changePassword(password: password)
    }
    
    func ChangePass(pass1: String, pass2: String) async throws {
        guard isValidPassword(password: pass2) else {
            throw ChangePasswordtErrors.invalidNewPass;
        }
    }
    
    private func isValidPassword(password: String) -> Bool {
        // checks if the password that is passed is a valid password
        // minimum 6 characters long
        // 1 uppercase character
        // 1 special character
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
}

struct ChangePasswordUI: View {
    @StateObject private var viewModel = ProfileViewModelChangePassword()
    @State private var oldPass: String = ""
    @State private var newPass: String = ""
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
                            TextField("Old Password...", text: $oldPass)
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
                                    try await viewModel.ChangePass(pass1: oldPass, pass2: newPass)
                                } catch LoginErrors.InvalidPassword {
                                    print("Invalid Password")
                                    showingAlert = true
                                    alertMessage = "Invalid Password. Password must be minimum 6 characters long and must contain a capital letter and a special character"
                                }
                                do {
                                    
                                    try viewModel.ChangePassword(password: newPass)
                                } catch {
                                    print("issue")
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
                            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}


struct Change_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordUI()
    }
}
