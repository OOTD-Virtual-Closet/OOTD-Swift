//
//  Profile.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 2/16/24.
//

import Foundation
import SwiftUI
import UIKit


@MainActor
final class ProfileViewModel: ObservableObject {
    func signOut() throws {
        try AuthManager.shared.signout()
    }
}

struct ProfileSummary: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var isAuthenticated: Bool
    var email = UserDefaults.standard.string(forKey: "email") ?? "tempEmail"
    var uid = UserDefaults.standard.string(forKey: "uid") ?? "uid"
//    var profile: Profile

    var body: some View {
        NavigationView {
            ZStack {
                //Color("settingsBackground")
                VStack {
                    Text("\nSettings\n")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding()
                        .foregroundStyle(Color(hex:"CBC3E3"))
                    
                    //display username and email
                    Text("profile.uid = " + uid)
                        .bold()
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.heavy)
                        .padding(.horizontal)
                        .foregroundColor(Color(hex:"898989"))
                    
                    Text("email: " + email + "\n")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .foregroundColor(Color(hex:"898989"))
                    
                    VStack {
                        
                        //change password button
                        Button(action: {
                            //TODO: ADD STUFF TO CHANGE PASSWORD
                            
                        }, label: {
                            Text("Change Password")
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .background(Color("UIpurple"))
                                .cornerRadius(10)
                        })
                        
                        .padding(.horizontal)
                   
                        //delete account button
                        Button(action: {
                            
                        }, label: {
                            Text("Delete Account")
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .background(Color("UIpurple"))
                                .cornerRadius(10)
                        })
                        .padding()
                        
                        Button(action: {
                            print("Log out pressed")
                            Task {
                                do {
                                    try viewModel.signOut()
                                    isAuthenticated = false
                                } catch {
                                    print(error)
                                }
                            }
                        }, label: {
                            Text("Log Out")
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .background(Color("UIpurple"))
                                .cornerRadius(10)
                        })
                        .padding()
                        .navigationBarBackButtonHidden(true) 
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
            }
        }
    }
    
}


struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = false
        ProfileSummary(isAuthenticated:$isAuthenticated)
    }
}
