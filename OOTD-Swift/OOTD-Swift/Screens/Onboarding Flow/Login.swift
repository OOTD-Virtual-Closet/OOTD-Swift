//
//  Login.swift
//  OOTD-Swift
//
//  Created by Atharva Gupta on 2/15/24.
//

import SwiftUI
import GoogleSignInSwift

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var uid = ""
    @Published var password = ""
    
    func login() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No user email or password found")
            return
        }
        let user = try await AuthManager.shared.signIn(email: email, password: password)
        print("log in completed")
        print(user.email)
        print(user.uid)
        UserDefaults.standard.set(user.email, forKey: "email")
        UserDefaults.standard.set(user.uid, forKey: "uid")
        print("Success")
    }
}

struct Login: View {
//    @Binding var currentShowingView: String
    @StateObject private var viewModel = LoginViewModel()
    @State private var loginButton: Bool = false
    @State private var signUpActive: Bool = false
    @State private var showSignInView: Bool = false
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
                        SecureField("Password...", text: $viewModel.password)
                        
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
                        print("Login in presed")
                        Task {
                            do {
                                try await viewModel.login()
                                loginButton = true
                            } catch {
                                print("log in Error \(error)")
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
                    .background(NavigationLink("",destination: ProfileSummary(showSignInView: $showSignInView), isActive: $loginButton).hidden())
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
                        .background(NavigationLink(destination: Signup(), isActive: $signUpActive) { EmptyView() }.hidden())
                        .navigationBarBackButtonHidden(true) 
                    }
                    
                    Text("OR")
                        .padding()
                        .foregroundStyle(Color(hex:"898989"))
                        .fontWeight(.bold)
                    
                    
                    //#####NEED TO IMPLEMENT#####
//                    NavigationLink (destination: DashboardNav(userProfile:"tempstring"),
//                                    label: {
//                        GoogleSignInButton(action: loginVM.signUpWithGoogle)
//                            .padding()
//                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
//                            .cornerRadius(10)
//                            .padding(.vertical, 8)
//                        }
//                    )
                    
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
//        NavigationStack {
        Login()
            .environmentObject(LogInVM())
//        }
    }
}
