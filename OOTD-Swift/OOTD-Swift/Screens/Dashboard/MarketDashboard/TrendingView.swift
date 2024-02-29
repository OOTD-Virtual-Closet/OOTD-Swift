//
//  TrendingView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

struct TrendingView: View {
    var body: some View {
        VStack {
            Text("Trending 🔥")
                .font(.system( size: 25))
                .fontWeight(.heavy)
                .padding(.top, 10)
            Text("36 items")
                .foregroundColor(.gray)
                .font(.system( size: 13))
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .padding(.top, 5)
                .padding(.leading, 10)
            HStack {
                Image(systemName: "cart.fill")
                Text("Shopping Cart")
                    .foregroundColor(.black)
                    .font(.system( size: 18))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
            }
            .padding(.leading, 35)
            Spacer()
            .padding(.top, 20)
        }
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}
