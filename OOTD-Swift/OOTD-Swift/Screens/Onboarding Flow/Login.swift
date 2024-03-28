//
//  Login.swift
//  OOTD-Swift
//
//  Created by Atharva Gupta on 2/15/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignInSwift
import LocalAuthentication
import GoogleSignIn

enum LoginErrors: Error{
    case BlankForm
    case InvalidPassword
    case InvalidUsername
    case InvalidPasswordUsername
    case InvalidLogin
    case UserDoesNotExist
    case WrongPassword
    case InvalidSignup
}

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var uid = ""
    @Published var password = ""
    
    func login() async throws {
        print("Email: \(email)")
        print("Password: \(password)")
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
        
        do {
            let user = try await AuthManager.shared.signIn(email: email, password: password)
            print("log in completed")
            print(user.email)
            print(user.uid)
            UserDefaults.standard.set(user.email, forKey: "email")
            UserDefaults.standard.set(user.uid, forKey: "uid")
            print("Success")
        } catch let error as NSError {
            if error.domain == AuthErrorDomain {
                let errorCode = AuthErrorCode(_nsError: error)

                    print("Error: \(error.localizedDescription)")
                    throw LoginErrors.InvalidLogin
            } else {
                // If the error is not from Firebase Auth
                print("Non-Firebase Error: \(error.localizedDescription)")
                throw LoginErrors.InvalidLogin
            }
        }

    }
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase config")
        }
        let config = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
            print("There is no root view controller")
            return false
        }
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                //throw AuthenticationError.tokenError(message: "ID Token missing")
                throw AuthenticationError.tokenError(message: "ID token missing")
                print("Error")
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            let result = try await Auth.auth().signIn(with: credential)
            let firebase = result.user
            print("User \(firebase.uid) has signed in ")
            return true
        } catch {
            print(error.localizedDescription)
            let errorMessage = error.localizedDescription
            return false
        }
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

struct Login: View {
//    @Binding var currentShowingView: String
    @StateObject private var viewModel = LoginViewModel()
    //@State private var loginButton: Bool = false
    @State private var signUpActive: Bool = false
    @State private var showSignInView: Bool = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @Binding var isAuthenticated:Bool
    @EnvironmentObject var loginVM: LogInVM
    
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
                VStack {
                    Text("Hello Welcome!")
                        .frame(maxWidth: 300, alignment: .center)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color(hex:"CBC3E3"))
                        .padding(.bottom, 20)
                        .padding(.top, 5)
                    Text("Welcome to OOTD")
                        .foregroundStyle(Color(hex:"898989"))
                        .font(.title3)
                        .fontWeight(.heavy)
                    Text("Your virtual closet")
                        .foregroundStyle(Color(hex:"898989"))
                        .font(.title3)
                        .fontWeight(.heavy)

                }
                VStack {
                    HStack {
                        TextField("Email...", text: $viewModel.email)
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
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2.0)
                            .foregroundColor(Color(hex:"898989"))
                    )
                    .padding()
                    HStack {
                        SecureField("Password...", text: $viewModel.password)
                        if (viewModel.password == "") {
                            Image(systemName: "lock.fill")
                                .fontWeight(.bold)
                        } else {
                            Image(systemName: isValidPassword(viewModel.password) ? "checkmark" : "xmark")
                                .fontWeight(.bold)
                                .foregroundColor(isValidPassword(viewModel.password) ? .green : .red)
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2.0)
                            .foregroundColor(Color(hex:"898989"))
                    )
                    .padding()
                    
                    Button(action: {
                        print("Forgot Password tapped")
                    }) {
                        Text("Forgot Password?")
                            .foregroundStyle(Color(hex: "CBC3E3"))
                            .fontWeight(.heavy)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 20)
                            .padding(.bottom, 30)
                    }
                }
                
                VStack (spacing:10){
                    
                    Button {
                        print("Login in Pressed")
                        Task {
                            do {
                                try await viewModel.login()
                                isAuthenticated = true
                            } catch LoginErrors.BlankForm {
                                print("Password or Username Field is blank")
                                showingAlert = true
                                alertMessage = "Password or username field is blank"
                            } catch LoginErrors.InvalidPasswordUsername {
                                showingAlert = true
                                alertMessage = "Invalid Password and Username"
                            } catch LoginErrors.InvalidPassword {
                                print("Invalid Password")
                                showingAlert = true
                                alertMessage = "Invalid Password. Password must be minimum 6 characters long and must contain a capital letter and a special character"
                            } catch LoginErrors.WrongPassword {
                                showingAlert = true
                                alertMessage = "The password you have entered doesn't match with username credentials"
                            } catch LoginErrors.UserDoesNotExist {
                                showingAlert = true
                                alertMessage = "User does not exist"
                            } catch LoginErrors.InvalidLogin {
                                showingAlert = true
                                alertMessage = "Invalid Login Credentials"
                            } catch LoginErrors.InvalidUsername {
                                print("Invalid Username")
                                showingAlert = true
                                alertMessage = "The username you have entered seems to be invalid"
                            }
                        }
                    } label: {
                        Text("Login")
                            .font(.title3)
                            .foregroundColor(.black)
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
                    
                    HStack {
                        Button("Authenticate") {
                            biometricAuthentication()
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Authentication Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    
                    HStack {
                        Text("Don't have an account?")
                            .foregroundStyle(Color(hex:"898989"))
                            .fontWeight(.heavy)
                        Button(action: {
                            print("Sign Up")
                            signUpActive = true
                        }) {
                            Text("Sign Up?")
                                .foregroundStyle(Color(hex: "CBC3E3"))
                                .fontWeight(.heavy)
                        }
                        .background(NavigationLink(destination: Signup(isAuthenticated: $isAuthenticated), isActive: $signUpActive) { EmptyView() }.hidden())
                        .navigationBarBackButtonHidden(true)
                    }
                    
                    Text("OR")
                        .padding()
                        .foregroundStyle(Color(hex:"898989"))
                        .fontWeight(.bold)
                    

                    // #### NEED TO ADD NAV LOCATIONS ####
                    Button(action: {
                        Task {
                                let success = await viewModel.signInWithGoogle()
                                if success {
                                    print("Login with Google successful")
                                    isAuthenticated = true
                                } else {
                                    // Handle sign-in failure
                                    alertMessage = "Login with Google unsuccessful"
                                    print("Login with Google unsuccessful")
                                    isAuthenticated = false
                                    showingAlert = true
                                }
                            }
                    }) {
                        Text("Login with Google")
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background() {
                                Image("Google")
                                    .padding(.leading)
                                    .frame(width: 30)
                            }
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .buttonStyle(.bordered)
                //    GoogleSignInButton(action: {
                     //   loginVM.signUpWithGoogle()
                    //    isAuthenticated = true;
                    //})
//                        .foregroundColor(.white)
//                        .font(.title)
//                        .bold()
//                        .frame(maxWidth: 350)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//
                    Button (action: {
                       // handle google login
                        print("Login with Apple")
                    }) {
                        HStack {
                            Text("Log In with Apple")
                                .foregroundColor(.black)
                        }
                    }
                }
                
                Spacer()
            }
        }

    }
    
    func biometricAuthentication() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "This is for quick login purposes!") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // User authenticated successfully, update your state here
                        self.isAuthenticated = true
                    } else {
                        // Authentication failed, show an alert or update your state accordingly
                        self.showingAlert = true
                        self.alertMessage = "Authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")"
                    }
                }
            }

        } else {
            print("No Face ID")
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

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        @State var showSignInView = false
        @State var isAuthenticated = false
        NavigationStack {
        Login(isAuthenticated: $isAuthenticated)
            .environmentObject(LogInVM())
        }
    }
}
