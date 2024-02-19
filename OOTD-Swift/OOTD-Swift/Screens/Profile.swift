//
//  Profile.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 2/16/24.
//

import Foundation
import SwiftUI
import UIKit

struct Profile {
    var username: String
    var email: String
    var password: String

    static let `default` = Profile(username: "[username]", email: "[email]", password: "")

}

struct ProfileSummary: View {
    var profile: Profile

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
                    Text(profile.username)
                        .bold()
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.heavy)
                        .padding(.horizontal)
                        .foregroundColor(Color(hex:"898989"))
                    
                    Text("email: " + profile.email + "\n")
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
                            //TODO: ADD STUFF TO DELETE ACCOUNT
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


struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary(profile: Profile.default)
    }
}
