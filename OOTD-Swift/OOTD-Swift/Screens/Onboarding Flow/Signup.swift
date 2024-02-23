//
//  Login.swift
//  OOTD-Swift
//
//  Created by Atharva Gupta on 2/17/24.
//

import SwiftUI
import GoogleSignInSwift
//import GoogleSignInSwift
@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var uid = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No user email or password found")
            throw LoginErrors.BlankForm
        }
        guard isValidEmail(email) || isValidPassword(password) else {
            throw LoginErrors.InvalidPasswordUsername
        }
        guard isValidPassword(password) else {
            throw LoginErrors.InvalidPassword
        }
        guard isValidEmail(email) else {
            throw LoginErrors.InvalidUsername
        }
        let user = try await AuthManager.shared.createUser(email: email, password: password)
        print("Sign in completed")
        print(user.email)
        print(user.uid)
        UserDefaults.standard.set(user.email, forKey: "email")
        UserDefaults.standard.set(user.uid, forKey: "uid")
        var userViewModel = UserViewModel()
        userViewModel.setInitData(newUser: User(
            uid: user.uid,
            email: user.email ?? "emailUnknown",
            creationDate: Date()
        ))
        print("Success")
        email = user.email ?? ""
        uid = user.uid
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)

    }
    private func isValidPassword(_ password: String) -> Bool {
        // checks if the password that is passed is a valid password
        // minimum 6 characters long
        // 1 uppercase character
        // 1 special character
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
}


final class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            // have some error handling here; most likely show error on screen and renavigate to login page smth like that
            return
        }
        Task {
            do {
                let returnedUserData = try await AuthManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
            } catch {
                print("Error \(error)")
            }
        }
    }
}

struct Signup: View {
<<<<<<< HEAD
    //@State private var email: String = ""
    //@State private var password: String = ""
    
    @StateObject private var viewModel = SignUpViewModel()
=======
    
    @StateObject private var viewModel = SignUpViewModel()
    @State private var isActive: Bool = false
    @State private var shouldNavigateToProfile = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @EnvironmentObject var loginVM: LogInVM
    @Binding var isAuthenticated:Bool

    private func isValidPassword(_ password: String) -> Bool {
        // checks if the password that is passed is a valid password
        // minimum 6 characters long
        // 1 uppercase character
        // 1 special character
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
>>>>>>> dev
    
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
<<<<<<< HEAD
                        TextField("Enter username...", text: $viewModel.email)
    //                        .foregroundStyle(Color(hex:"898989"))
                        Image(systemName: "checkmark")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
=======
                        TextField("Enter email...", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        if (viewModel.email == "") {
                            Image(systemName: "envelope.fill")
                                .fontWeight(.bold)
                        } else {
                            Image(systemName: viewModel.email.isValidEmail() ? "checkmark" : "xmark")
                                .fontWeight(.bold)
                                .foregroundColor(viewModel.email.isValidEmail() ? .green : .red)
                        }
>>>>>>> dev
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
<<<<<<< HEAD
    //                        .foregroundStyle(Color(hex:"898989"))
                        Image(systemName: "checkmark")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
=======

                        if (viewModel.password == "") {
                            Image(systemName: "lock.fill")
                                .fontWeight(.bold)
                        } else {
                            Image(systemName: isValidPassword(viewModel.password) ? "checkmark" : "xmark")
                                .fontWeight(.bold)
                                .foregroundColor(isValidPassword(viewModel.password) ? .green : .red)
                        }
>>>>>>> dev
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
                                isAuthenticated = true
                            } catch LoginErrors.BlankForm {
                                print("Invalid Password or Username")
                                showingAlert = true
                                alertMessage = "Password or username field is blank"
                            } catch LoginErrors.InvalidPasswordUsername {
                                showingAlert = true
                                alertMessage = "Invalid Password and Username"
                            } catch LoginErrors.InvalidPassword {
                                print("Invalid Password")
                                showingAlert = true
                                alertMessage = "Invalid Password. Password must be minimum 6 characters long and must contain a capital letter and a special character"
                            } catch LoginErrors.InvalidUsername {
                                print("Invalid Username")
                                showingAlert = true
                                alertMessage = "The username you have entered seems to be invalid"
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
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    Text("OR")
                        .padding()
                        .foregroundStyle(Color(hex:"898989"))
                        .fontWeight(.bold)
                    
                    
                    //#####NEED TO IMPLEMENT#####
//                    GoogleSignInButton(action: loginVM.signUpWithGoogle)
//                        .foregroundColor(.white)
//                        .font(.title)
//                        .bold()
//                        .frame(maxWidth: 350)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
                    
                    
<<<<<<< HEAD
                    Button (action: {
                        viewModel.signIn()
                    }) {
                        HStack {
                            Text("Sign up In with Google")
                                .foregroundColor(.black)
                        }
                    }
=======
>>>>>>> dev
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
        @State var isAuthenticated = false
        NavigationStack {
            Signup(isAuthenticated: $isAuthenticated)
                .environmentObject(LogInVM())
        }
    }
}
