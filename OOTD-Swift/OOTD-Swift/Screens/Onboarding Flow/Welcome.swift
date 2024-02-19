//
//  Welcome.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 2/18/24.
//

import SwiftUI
import UIKit

struct WelcomePage1: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    HStack {
                        Text("Hello Welcome!")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color(hex:"CBC3E3"))
                    }
                    .padding()
                    .padding()
                    VStack {
                        Text("Welcome to OOTD")
                            .foregroundStyle(Color(hex:"898989"))
                            .font(.title3)
                            .fontWeight(.heavy)
                        Text("Your virtual closet")
                            .foregroundStyle(Color(hex:"898989"))
                            .font(.title3)
                            .fontWeight(.heavy)
                        Image("Welcome_Closet")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:175, height:350)
                            .clipped()
                        Text("You can view all the clothing items you've uploaded in your Closet! 🧥 You can create outfits and favorites them too 💛")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)
                            .padding(.vertical)
                            .foregroundColor(Color(hex:"898989"))
                        
                    }
                    
                    VStack {
                        
                        //move next
                        Button(action: {
                            //TODO: MOVE ONTO PREVIOUS SCREEN
                            
                        }, label: {
                            Text("BACK")
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .background(Color("UIpurple"))
                                .cornerRadius(10)
                        })
                        
                        .padding(.horizontal)
                    }
                    VStack {
                        
                        //move next
                        Button(action: {
                            //TODO: MOVE ONTO NEXT SCREEN
                            
                        }, label: {
                            Text("NEXT")
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .background(Color("UIpurple"))
                                .cornerRadius(10)
                        })
                        
                        .padding(.horizontal)
                    }
                    
                    
                }
            }
        }
    }
}

struct WelcomePage2: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    HStack {
                        Text("Hello Welcome!")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color(hex:"CBC3E3"))
                    }
                    .padding()
                    .padding()
                    VStack {
                        Text("Welcome to OOTD")
                            .foregroundStyle(Color(hex:"898989"))
                            .font(.title3)
                            .fontWeight(.heavy)
                        Text("Your virtual closet")
                            .foregroundStyle(Color(hex:"898989"))
                            .font(.title3)
                            .fontWeight(.heavy)
                        Image("Welcome_Shop")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:175, height:350)
                            .clipped()
                        Text("You also have access to our marketplace where you can view and buy trending clothes, and get recommendations based on your style! 😍")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)
                            .padding(.vertical)
                            .foregroundColor(Color(hex:"898989"))
                        
                    }
                    
                    VStack {
                        
                        //move next
                        Button(action: {
                            //TODO: MOVE ONTO PREVIOUS SCREEN
                            
                        }, label: {
                            Text("BACK")
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .background(Color("UIpurple"))
                                .cornerRadius(10)
                        })
                        
                        .padding(.horizontal)
                    }
                    VStack {
                        
                        //move next
                        Button(action: {
                            //TODO: MOVE ONTO NEXT SCREEN
                            
                        }, label: {
                            Text("NEXT")
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .background(Color("UIpurple"))
                                .cornerRadius(10)
                        })
                        
                        .padding(.horizontal)
                    }
                    
                    
                }
            }
        }
    }
}

struct WelcomePage3: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    HStack {
                        Text("Hello Welcome!")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color(hex:"CBC3E3"))
                    }
                    .padding()
                    .padding()
                    VStack {
                        Text("Welcome to OOTD")
                            .foregroundStyle(Color(hex:"898989"))
                            .font(.title3)
                            .fontWeight(.heavy)
                        Text("Your virtual closet")
                            .foregroundStyle(Color(hex:"898989"))
                            .font(.title3)
                            .fontWeight(.heavy)
                        Image("Welcome_Social_Media")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:175, height:350)
                            .clipped()
                        Text("Add friends and share your OOTD 👕 Keep in mind that you can only view your friends' posts if you post 📸")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)
                            .padding(.vertical)
                            .foregroundColor(Color(hex:"898989"))
                        
                    }
                    
                    VStack {
                        
                        //move next
                        Button(action: {
                            //TODO: MOVE ONTO PREVIOUS SCREEN
                            
                        }, label: {
                            Text("BACK")
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .background(Color("UIpurple"))
                                .cornerRadius(10)
                        })
                        
                        .padding(.horizontal)
                    }
                    VStack {
                        
                        //move next
                        Button(action: {
                            //TODO: MOVE ONTO NEXT SCREEN
                            
                        }, label: {
                            Text("NEXT")
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .background(Color("UIpurple"))
                                .cornerRadius(10)
                        })
                        
                        .padding(.horizontal)
                    }
                    
                    
                }
            }
        }
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePage1()
    }
}
