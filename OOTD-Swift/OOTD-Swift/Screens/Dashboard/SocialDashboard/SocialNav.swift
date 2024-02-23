//
//  SocialNav.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/22/24.
//

import SwiftUI

struct SocialNav: View {
    @State private var selectedContent: Int? = 1
    var body: some View {
        VStack {
            Text("Social")
                .foregroundStyle(Color(hex:"898989"))
                .font(.title3)
                .fontWeight(.heavy)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
            HStack{
                // Buttons to select content
                Button(action: {
                    self.selectedContent = 1
                }) {
                    Text("Friends")
                }
                Spacer()
                Button(action: {
                    self.selectedContent = 2
                }) {
                    Text("Feeds")
                }
                Spacer()
                Button(action: {
                    self.selectedContent = 3
                }) {
                    Text("My Posts")
                }
            }
            Spacer()
            // Content views
            if selectedContent == 1 {
                FriendsView()
            } else if selectedContent == 2 {
                FeedView()
            } else if selectedContent == 3 {
                PostsView()
            }
            Spacer()
        }
        .padding()
        
    }
}

struct SocialNav_Previews: PreviewProvider {
    static var previews: some View {
        SocialNav()
    }
}
