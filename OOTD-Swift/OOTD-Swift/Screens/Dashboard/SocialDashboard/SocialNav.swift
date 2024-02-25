//
//  SocialNav.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/22/24.
//

import SwiftUI

struct SocialNav: View {
    @State private var selectedContent: Int? = 1
    @Binding var isAuthenticated:Bool
    var tabImageNames : [String] = ["person.2", "square.stack", "photo"]
    var tabBarOptions: [String] = ["Friends", "Feed", "Posts"]
    @State var currentTab: Int = 0

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack{
                HStack{
                    Spacer()
                    NavigationLink(destination: ProfileSummary(isAuthenticated: $isAuthenticated)) {
                        Image("UserIcon")
                            .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                .padding(.trailing)
                    }
                }
                Spacer()
            }
            VStack {
                Text("Social")
                    .foregroundColor(.black)
                    .font(.system( size: 25))
                    .fontWeight(.heavy)
                ZStack (alignment: .top) {
                    TabView(selection: self.$currentTab) {
                        FriendsView()
                            .tag(0)
                        FeedView()
                            .tag(1)
                        PostsView().tag(2)

                    }.padding (.top, 50)
                    TabBarViewV2(currentTab: self.$currentTab, tabBarOptions: tabBarOptions, tabBarImages: tabImageNames)
                }
                Spacer()
            }
            .padding(.bottom, -100)
            
            }
            .padding()

        }
    }


struct SocialNav_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        SocialNav(isAuthenticated: $isAuthenticated)
    }
}
