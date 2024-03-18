//
//  PostsView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

struct PostsView: View {
    @State var addPostPresented = false
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                        VStack(spacing: 20) {
                            ForEach(0..<10) { _ in
                                    PostView()
                            }
                        }
                       
                    }
            .padding (.top, 50)
            Button(action: {
                           addPostPresented.toggle()
                       }) {
                           HStack {
                               Spacer()
                               Image(systemName: "plus")
                                   .font(.title)
                                   .foregroundColor(.black)
                                   .frame(width: 50, height: 50)
                                   .background(Color(hex: "E1DDED"))
                                   .clipShape(Circle())
                                   .overlay(Circle()
                                            .stroke(Color.black,
                                                    lineWidth: 2)
                                    )
                                   .padding(.trailing, 20)
                           }
                       }
                       .padding(.bottom, 50)
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
