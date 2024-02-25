//
//  PostsView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

struct PostsView: View {
    var body: some View {
        ScrollView {
                    VStack(spacing: 20) {
                        ForEach(0..<10) { _ in
                            UserPost()
                        }
                    }
                   
                }.padding (.top, 50)
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
