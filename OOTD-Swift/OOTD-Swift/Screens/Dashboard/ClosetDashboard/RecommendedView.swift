//
//  TrendingView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

struct RecommendedView: View {
    @State private var currentIndex = 0
    @State private var isExpanded = false
    var outfits: [Outfit]?
    
    var body: some View {
        VStack {
            Text("Recommended Outfits")
                .foregroundColor(.black)
                .font(.system(size: 20))
                .fontWeight(.heavy)
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                VStack {
                    if let outfit = outfits?[currentIndex] {
                        Outfits(item: outfit.id)
                            .frame(width: isExpanded ? 320 : 200, height: isExpanded ? 420 : 250)
                            .padding(.bottom, 30)
                    } else {
                        Text("No outfits available")
                            .foregroundColor(.black)
                            .padding(.vertical, 20)
                    }
                    
                    if isExpanded {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(outfits?[currentIndex].name ?? "")
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                    .padding(.top, 10)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .background(Color.uIpurple.opacity(0.6))
                        .cornerRadius(15)
                    }
                }
                .background(Color.uIpurple.opacity(0.6))
                .cornerRadius(15)
            }
            
            HStack(spacing: 20) {
                Button(action: {
                    withAnimation {
                        currentIndex = max(currentIndex - 1, 0)
                    }
                }) {
                    Text("Back")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    withAnimation {
                        currentIndex = min(currentIndex + 1, (outfits?.count ?? 0) - 1)
                    }
                }) {
                    Text("Next")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color.uIpurple)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
        }
    }
}
