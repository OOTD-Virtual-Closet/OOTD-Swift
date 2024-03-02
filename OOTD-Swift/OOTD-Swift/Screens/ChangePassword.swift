//
//  ChangePassword.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 3/2/24.
//


import SwiftUI

@MainActor
final class ProfileViewModelChangePassword: ObservableObject {
    func ChangePassword(password:String) throws {
        try AuthManager.shared.changePassword(password: password)
    }
}

struct ChangePasswordUI: View {
    @StateObject private var viewModel = ProfileViewModelChangePassword()
    @State private var oldPass: String = ""
    @State private var newPass: String = ""
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
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .frame(height:50)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .background(Color("UIpurple"))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        Button (action: {
                            do {
                                try viewModel.ChangePassword(password: newPass)
                            } catch {
                                print("An error occurred: \(error)")
                            }
                        }) {
                            HStack {
                                @State var isAuthenticated = false
                                NavigationLink(destination: Signup(isAuthenticated: $isAuthenticated)
                                    .environmentObject(LogInVM())) {
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
                        }
                        .padding(.horizontal)
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
