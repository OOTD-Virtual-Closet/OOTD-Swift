//
//  DeleteAccount.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 2/16/24.
//

import SwiftUI

struct DeleteAccount: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPass: String = ""
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    HStack {
                        Text("Delete Account!")
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
                            TextField("Email...", text: $email)
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
                            TextField("Password...", text: $password)
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
                            TextField("Confirm Password...", text: $confirmPass)
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
                        
                        NavigationLink(destination: DeleteAccount()) {
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
                        
                        NavigationLink(destination: Signup()) {
                            Text("DELETE")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .frame(height:50)
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .background(Color("UIpurple"))
                            .cornerRadius(10)
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
        DeleteAccount()
    }
}
