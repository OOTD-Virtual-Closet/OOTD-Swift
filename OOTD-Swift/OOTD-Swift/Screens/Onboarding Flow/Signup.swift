//
//  Login.swift
//  OOTD-Swift
//
//  Created by Atharva Gupta on 2/17/24.
//

import SwiftUI
//import GoogleSignInSwift

struct Signup: View {
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                HStack {
                    Text("OOTD SIGN UP!")
                        .padding(.top, 30)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color(hex:"CBC3E3"))
                }
                .padding()
                .padding(.bottom, 5)
                VStack {
                    Text("Let's get started on your account")
                        .foregroundStyle(Color(hex:"898989"))
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .padding(.bottom, 40)

                }
                VStack {
                    HStack {
                        TextField("Enter username...", text: $email)
    //                        .foregroundStyle(Color(hex:"898989"))
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
                        TextField("Enter password...", text: $password)
    //                        .foregroundStyle(Color(hex:"898989"))
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
                Spacer()
                VStack (spacing:20){
                    Button("Login") {
                        // handle login stuff
                    }
                    .padding()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(Color(hex:"CBC3E3"))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    HStack {
                        Text("Already have an account?")
                            .foregroundStyle(Color(hex:"898989"))
                            .fontWeight(.heavy)
                        Button("Login!") {
                            // handle signup
                        }
                        .foregroundColor(Color(hex:"CBC3E3"))
                        .fontWeight(.heavy)
                    }
                    
                    Text("OR")
                        .padding()
                        .foregroundStyle(Color(hex:"898989"))
                        .fontWeight(.bold)
                    
                    
                    //#####NEED TO IMPLEMENT#####
                    
                    Button (action: {
                       // handle google login
                        print("Sign Up with google")
                    }) {
                        HStack {
                            Text("Sign up In with Google")
                                .foregroundColor(.black)
                        }
                    }
                    Button (action: {
                       // handle google login
                        print("Sign up with Apple")
                    }) {
                        HStack {
                            Text("Sign up with Apple")
                                .foregroundColor(.black)
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
}


struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        Signup()
    }
}
