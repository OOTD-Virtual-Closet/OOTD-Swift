//
//  Login.swift
//  OOTD-Swift
//
//  Created by Atharva Gupta on 2/15/24.
//

import SwiftUI
//import GoogleSignInSwift

struct Login: View {
//    @Binding var currentShowingView: String
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isActive: Bool = false
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                HStack {
                    Text("Hello Welcome!")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color(hex:"CBC3E3"))
                }
                .padding()
                .padding()
                VStack {
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
                        TextField("Email...", text: $email)
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
                        SecureField("Password...", text: $password)
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
//                    NavigationLink (destination: DashboardNav(userProfile:"tempstring"),
//                                    label: {
//                        Text("Login")
//                            .padding()
//                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
//                            .background(Color(hex:"CBC3E3"))
//                            .foregroundColor(.black)
//                            .fontWeight(.bold)
//                            .cornerRadius(10)
//                            .padding(.horizontal)
//                            .padding(.bottom, 20)
//                        }
//                    )
                    HStack {
                        Text("Don't have an account?")
                            .foregroundStyle(Color(hex:"898989"))
                            .fontWeight(.heavy)
//                        NavigationLink(
//                            destination: Signup(), label: {
//                                Text("Signup!")
//                            }
//                        )
//                        .foregroundColor(Color(hex:"CBC3E3"))
//                        .fontWeight(.heavy)
                        Button(action: {
                            print("Sign Up")
                            self.isActive = true
                        }) {
                            Text("Sign Up?")
                                .foregroundStyle(Color(hex: "CBC3E3"))
                                .fontWeight(.heavy)
                        }
                        .background(NavigationLink(destination: Signup(), isActive: $isActive) { EmptyView() }.hidden())
                        .navigationBarBackButtonHidden(true) 
                    }
                    
                    Text("OR")
                        .padding()
                        .foregroundStyle(Color(hex:"898989"))
                        .fontWeight(.bold)
                    
                    
                    //#####NEED TO IMPLEMENT#####
                    
                    Button (action: {
                       // handle google login
                        print("Login with google")
                    }) {
                        HStack {
                            Text("Log In with Google")
                                .foregroundColor(.black)
                        }
                    }
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
//        }
    }
}
