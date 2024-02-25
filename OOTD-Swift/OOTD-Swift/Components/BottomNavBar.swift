//
//  BottomNavBar.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/15/24.
//

import SwiftUI

struct BottomNavBar: View {
    @Binding var isAuthenticated: Bool
    @Binding var selectedTab: Int // Add binding to selectedTab
        
        var body: some View {
            ZStack {
                Color.white
                    .frame(width: 393, height: 76)
                HStack {
                    Button(action: {
                        selectedTab = 1 // Update selectedTab when Market button is tapped
                    }) {
                        Image(systemName: "cart")
                            .resizable()
                            .foregroundColor(Color(red: 0.69, green: 0.69, blue: 0.69))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 3 // Update selectedTab when Closet button is tapped
                    }) {
                        Image(systemName: "tshirt")
                            .resizable()
                            .foregroundColor(Color(red: 0.69, green: 0.69, blue: 0.69))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 2 // Update selectedTab when Social button is tapped
                    }) {
                        Image(systemName: "camera.shutter.button")
                            .resizable()
                            .foregroundColor(Color(red: 0.69, green: 0.69, blue: 0.69))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                }
                .padding(.bottom, 20)
                .background(Color.white)
                .frame(width: UIScreen.main.bounds.width - 40, height:50)

            }
  
        }
    }

struct BottomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        @State var selectedTab = 1
        BottomNavBar(isAuthenticated: $isAuthenticated, selectedTab: $selectedTab)
    }
}
