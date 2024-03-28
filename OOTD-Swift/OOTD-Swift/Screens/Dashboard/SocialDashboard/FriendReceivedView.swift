//
//  FriendReceivedView.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 3/28/24.
//

import SwiftUI

struct FriendReceivedView: View {
    @State private var searchText = ""
    @State private var isEditing = false
    var body: some View {
        ZStack(alignment: .top) {
                ScrollView {
                    VStack {
                        ZStack {
                                    TextField("", text: $searchText, onEditingChanged: { editing in
                                        isEditing = editing
                                    })
                                    .padding(.leading, 30)
                                    .frame(width: UIScreen.main.bounds.width - 90, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color(hex: "F4F4F4"))
                                            .padding(.leading, 15)
                                    )
                                    .overlay(
                                        HStack {
                                            Image(systemName: "magnifyingglass")
                                                .resizable()
                                                .foregroundColor(.black)
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                .padding(.leading, 27)
                                            Text("Search...")
                                                .foregroundColor(.black)
                                                .font(.system(size: 17))
                                                .fontWeight(.heavy)
                                                .padding(.leading, 5)
                                            Spacer()
                                        }
                                        .opacity(isEditing || !searchText.isEmpty ? 0 : 1)
                                    )
                                }
                                VStack(spacing: 20) {
                                    ForEach(0..<10) { _ in
                                        RequestReceivedDisplay()
                                    }
                                }.padding(.top, 20)
                    }
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(height: 100)
                        .ignoresSafeArea(.all)
                }.padding (.top, 50)
            Rectangle()
                .foregroundColor(Color(hex: "9278E0"))
                .frame(height: UIScreen.main.bounds.height / 10)
                .ignoresSafeArea(.all)
            HStack {
               
                Spacer()
                Text("Friend Requests Received")
                    .foregroundColor(.white)
                    .font(.system( size: 20))
                    .fontWeight(.bold)
                Spacer()
            }.padding(.top, 20)
        }
       
 
    }
}
