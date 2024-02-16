//
//  BottomNavBar.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/15/24.
//

import SwiftUI

struct BottomNavBar: View {
    var body: some View {
        NavigationView {
            HStack {
                NavigationLink(destination: Text("Screen One")) {
                    Image(systemName: "camera")
                        .resizable()
                        .foregroundColor(Color(red: 0.69, green: 0.69, blue: 0.69))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                
                Spacer()
                
                NavigationLink(destination: Text("Screen 2")) {
                    Image(systemName: "tshirt")
                        .resizable()
                        .foregroundColor(Color(red: 0.69, green: 0.69, blue: 0.69))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                
                Spacer()
                
                NavigationLink(destination: Text("Screen3")) {
                    Image(systemName: "camera.shutter.button")
                        .resizable()
                        .foregroundColor(Color(red: 0.69, green: 0.69, blue: 0.69))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
            }
            .padding()
            .background(.black)
        }
    }
}

struct BottomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBar()
    }
}
