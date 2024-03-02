//
//  FeedView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

struct FeedView: View {
    @State private var searchText = ""
    @State private var isEditing = false
    var body: some View {
        ScrollView {
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
                            Post()
                        }
                    }
                   
                }.padding (.top, 50)
    }
}

struct Post: View {
    var body: some View {
        VStack {
            HStack {
                Image("UserIcon")
                    .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                Text("User")
                    .foregroundColor(.black)
                    .font(.system( size: 15))
                    .fontWeight(.bold)
                Spacer()
            }.padding(.leading, 20)
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(hex: "E1DDED"))
                    .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                Spacer()
            }.padding(.leading, 20)
            HStack {
                Text("cool caption")
                    .foregroundColor(.black)
                    .font(.system( size: 12))
                    .fontWeight(.semibold)
                Spacer()
            }.padding(.leading, 25)
        }
    }
}

struct UserPost: View {
    var body: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(hex: "E1DDED"))
                    .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                Spacer()
            }.padding(.leading, 20)
            HStack {
                Text("cool caption")
                    .foregroundColor(.black)
                    .font(.system( size: 12))
                    .fontWeight(.semibold)
                Spacer()
            }.padding(.leading, 25)
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
