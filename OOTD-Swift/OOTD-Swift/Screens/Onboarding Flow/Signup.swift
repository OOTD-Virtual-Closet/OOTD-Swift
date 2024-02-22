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
    @Published var uid = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No user email or password found")
            return
        }
        let user = try await AuthManager.shared.createUser(email: email, password: password)
        print("Sign in completed")
        print(user.email)
        print(user.uid)
        UserDefaults.standard.set(user.email, forKey: "email")
        UserDefaults.standard.set(user.uid, forKey: "uid")
        print("Success")
        email = user.email ?? ""
        uid = user.uid
    }
}


struct Signup: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    @State private var isActive: Bool = false
    @State private var shouldNavigateToProfile = false
    
    private func isValidPassword(_ password: String) -> Bool {
        // checks if the password that is passed is a valid password
        // minimum 6 characters long
        // 1 uppercase character
        // 1 special character
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
    
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
                        let email = $viewModel.email
                        Image(systemName: viewModel.email.isValidEmail() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(viewModel.email.isValidEmail() ? .green : .red)
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
                        Image(systemName: isValidPassword(viewModel.password) ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword(viewModel.password) ? .green : .red)
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

extension String {
    func isValidEmail() -> Bool {
        // test@email.com == true
        // test.com == false
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        
        return regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) != nil
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
