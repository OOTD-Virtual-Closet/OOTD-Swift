//
//  FeedView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

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
                           // PostView()
                        }
                    }
                }.padding (.top, 50)
    }
}





struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
