//
//  MarketNav.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/22/24.
//

import SwiftUI

struct RecommendedOutfits: View {
    @State private var selectedContent: Int? = 1
    @Binding var isAuthenticated:Bool
    var tabBarOptions: [String] = ["Categories", "Trending"]
    @State var currentTab: Int = 0

    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Spacer()
                    Text("Recommended")
                        .foregroundColor(.black)
                        .font(.system( size: 25))
                        .fontWeight(.heavy)
                        .padding(.leading, 20)
                    Spacer()
                    NavigationLink(destination: ProfileSummary(isAuthenticated: $isAuthenticated)) {
                        Image("UserIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            .padding(.trailing)
                    }
                }
                
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(hex: "E1DDED"))
                        .frame(width: 275, height: 450)
                        .overlay(
                            Group {
                                
                            })
                }
                .padding()
                .padding()
                              
                VStack {
                    Button {
                        Task {
                            
                        }
                    } label: {
                        HStack {
                                Text("SKIP")
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .frame(height:50)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .background(Color("UIpurple"))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        HStack {
                                Text("ADD TO CLOSET")
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .frame(height:50)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .background(Color("UIpurple"))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
                          
                
            }

            }
        }
    }


struct RecommendedOutfits_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        RecommendedOutfits(isAuthenticated: $isAuthenticated)
    }
}
