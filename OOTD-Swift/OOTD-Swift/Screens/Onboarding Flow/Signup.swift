//
//  Login.swift
//  OOTD-Swift
//
//  Created by Atharva Gupta on 2/17/24.
//

import SwiftUI
//import GoogleSignInSwift

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No user email or password found")
            return
        }
        try await AuthManager.shared.createUser(email: email, password: password)
          print("Success")
        
    }
}


struct Signup: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    @State private var isActive: Bool = false
    @State private var shouldNavigateToProfile = false
    
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
                        TextField("Enter email...", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
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
                        SecureField("Enter password...", text: $viewModel.password)
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

                    Button {
                        print("Sign Up presed")
                        Task {
                            do {
                                try await viewModel.signIn()
                                shouldNavigateToProfile = true
                            } catch {
                                print("Sign up Error \(error)")
                            }
                        }
                    } label: {
                        Text("Create an Account")
                            .font(.title3)
                            .foregroundColor(Color(hex:"7B7A7A"))
                            .bold()
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: "CBC3E3"))
                                    .padding(.horizontal)
                            )
                            .padding(.bottom, 20)
                    }
                    .background(NavigationLink("", destination: ProfileSummary(showSignInView: $isActive), isActive: $shouldNavigateToProfile).hidden()) 
                    HStack {
                        Text("Already have an account?")
                            .foregroundStyle(Color(hex:"898989"))
                            .fontWeight(.heavy)
//                        self.currentShowingView = "login"
                        Button(action: {
                            print("Login")
                            self.isActive = true
                        }) {
                            Text("Login?")
                                .foregroundStyle(Color(hex: "CBC3E3"))
                                .fontWeight(.heavy)
                        }
                        .background(NavigationLink(destination: Login(), isActive: $isActive) { EmptyView() }.hidden())
                        .navigationBarBackButtonHidden(true) 
                        
//                        Button("Login?") {
//                            // handle signup
//                            print("Login pressed")
//                        }
                        .foregroundColor(Color(hex:"CBC3E3"))
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
        NavigationStack {
//            Signup()
            Signup()
        }
    }
}
