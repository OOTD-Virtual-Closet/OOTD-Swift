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

    static let `default` = Profile(username: "sanjheeg", email: "sanjheeg30@gmail.com", password: "")

}

struct ProfileHost: View {
    @State private var draftProfile = Profile.default

    var body: some View {
        Text("Profile for: \(draftProfile.username)")
    }
}

struct ProfileSummary: View {
    var profile: Profile

    var body: some View {
        NavigationView {
            ZStack {
                Color("settingsBackground")
                VStack(alignment: .leading, spacing: 4) {
                    Text("\nSettings\n")
                        .font(.title)
                    
                    //display username and email
                    Text(profile.username)
                        .bold()
                        .font(.headline)
                    Text("email: " + profile.email + "\n")
                    
                    //change password button
                    Button(action: {
                        //TODO: ADD STUFF TO CHANGE PASSWORD
                        
                    }, label: {
                        Text("Change Password")
                            .accentColor(.black)
                            .padding()
                            .background(
                                Color("UIpurple")
                                    .cornerRadius(10))
                    })
                    
                    
                    //delete account button
                    Button(action: {
                        
                    }, label: {
                        Text("Delete Account")
                            .accentColor(.red)
                            .padding()
                            .background(
                                Color("UIpurple")
                                    .cornerRadius(10))
                    })
                    
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
