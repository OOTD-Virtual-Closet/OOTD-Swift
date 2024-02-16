//
//  Login.swift
//  OOTD-Swift
//
//  Created by Atharva Gupta on 2/15/24.
//

import SwiftUI

struct Login: View {
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                HStack {
                    Text("Hello Welcome!")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color(hex:"CBC3E3"))
                }
                .padding()
                .padding()
                VStack {
                    Text("Welcome to OOTD")
                        .foregroundStyle(Color(hex:"898989"))
                        .bold()
                    Text("Your virtual closet")
                        .foregroundStyle(Color(hex:"898989"))
                        .bold()

                }
                HStack {
                    TextField("Email...", text: $email)
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
                    TextField("Password...", text: $password)
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
        Login()
    }
}