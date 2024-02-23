//
//  DeleteAccount.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 2/16/24.
//

import SwiftUI

@MainActor
final class ProfileViewModelDeleteAcc: ObservableObject {
    func DeleteAccount() throws{
        try AuthManager.shared.deleteAccount()
    }
    
    func GetAuthenticatedUser() throws -> AuthDataResultModel {
        let user = try AuthManager.shared.getAuthenticatedUser()
        return user
    }
    
}


struct DeleteAccountUI: View {
    @StateObject private var viewModel = ProfileViewModelDeleteAcc()
    @State private var user: String = ""
    @State private var confirmUser: String = ""
    @State private var confirmPass: String = ""
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
                    }
                    
                    VStack {
                        HStack {
                            TextField("Username...", text: $user)
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
                            TextField("Confirm Username...", text: $confirmUser)
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
                    }
                    
                    VStack {
                        NavigationLink(destination: ProfileSummary(profile: Profile.default)) {
                            //TODO: CHANGE PROFILE PARAMETERS W/ FIREBASE
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
                                try viewModel.DeleteAccount()
                            } catch {
                                print("An error occurred: \(error)")
                            }
                        }) {
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
                        
                    }
                    Spacer()
                }
            }
        }
    }
}


struct Delete_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountUI()
    }
}
