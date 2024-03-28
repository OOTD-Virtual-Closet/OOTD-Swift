//
//  FriendsView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

struct FriendsView: View {
    @State var showRequestsReceived = false
    @State var showRequestsSent = false
    @State private var searchText = ""
    @State private var isEditing = false
    var body: some View {
        ZStack(alignment: .bottom) {
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
                                    FriendDisplay()
                                }
                            }.padding(.top, 20)
                }
                Rectangle()
                    .foregroundColor(Color.white)
                    .frame(height: 100)
                    .ignoresSafeArea(.all)
            }.padding (.top, 50)
            HStack {
                Spacer()
                Button(action: {
                    showRequestsReceived.toggle()
                }) {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color.purple)
                        .frame(width:50, height: 50)
                        .overlay(
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        )
                }
                Button(action: {
                    showRequestsSent.toggle()
                }) {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color.purple)
                        .frame(width:50, height: 50)
                        .overlay(
                            Image(systemName: "paperplane")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        )
                }

            }.padding(.trailing, 20)
                .padding(.bottom, 70)

        } 
        .sheet(isPresented: $showRequestsReceived)
        {
            FriendReceivedView()
        }
        .sheet(isPresented: $showRequestsSent)
        {
            FriendRequestView()
        }
    }
}

struct FriendDisplay: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(hex: "E1DDED"))
                .frame(width: UIScreen.main.bounds.width - 40, height: 60)
            HStack {
                Image("UserIcon")
                    .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                Text("User")
                    .foregroundColor(.black)
                    .font(.system( size: 15))
                    .fontWeight(.bold)
                Spacer()
            }.padding(.leading, 40)

        }
    }
}

struct RequestSentDisplay: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(hex: "E1DDED"))
                .frame(width: UIScreen.main.bounds.width - 40, height: 60)
            HStack {
                Image("UserIcon")
                    .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                Text("User")
                    .foregroundColor(.black)
                    .font(.system( size: 15))
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "checkmark")
                    .foregroundColor(Color(hex: "9278E0"))
                    .frame(width: 30, height: 30)
                Image(systemName: "multiply")
                    .foregroundColor(Color.gray)
                    .frame(width: 30, height: 30)
            }.padding(.horizontal, 40)

        }
    }
}
struct RequestReceivedDisplay: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(hex: "E1DDED"))
                .frame(width: UIScreen.main.bounds.width - 40, height: 60)
            HStack {
                Image("UserIcon")
                    .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                Text("User")
                    .foregroundColor(.black)
                    .font(.system( size: 15))
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "checkmark")
                    .foregroundColor(Color(hex: "9278E0"))
                    .frame(width: 30, height: 30)
                Image(systemName: "multiply")
                    .foregroundColor(Color.gray)
                    .frame(width: 30, height: 30)
            }.padding(.horizontal, 40)

        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
