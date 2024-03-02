//
//  WelcomeDirections.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 3/2/24.
//

//
//  Welcome.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 2/19/24.
//

import SwiftUI
import UIKit

struct WelcomePage1: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Text("Welcome!")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color(hex:"CBC3E3"))
                    }
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
                    }
                    .padding()
                    .padding()
                    
                    VStack {
                        NavigationLink(destination: WelcomePage2()) {
                            Text("NEXT")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .frame(height:50)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .background(Color("UIpurple"))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        @State var isAuthenticated = false
                        NavigationLink(destination: Signup(isAuthenticated: $isAuthenticated)
                            .environmentObject(LogInVM())) {
                            Text("SKIP>")
                                .foregroundStyle(Color(hex: "CBC3E3"))
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                                .padding(.bottom, 30)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}


struct WelcomePage2: View {
    var body: some View {
        //NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    HStack {
                        Text("Closet!")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color(hex:"CBC3E3"))
                    }
                    .padding()
                    
                    VStack {
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
                    .padding()

                    VStack {
                        NavigationLink(destination: WelcomePage1()) {
                            Text("BACK")
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
                    
                    VStack {
                        NavigationLink(destination: WelcomePage3()) {
                            Text("NEXT")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .frame(height:50)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .background(Color("UIpurple"))
                            .cornerRadius(10)
                            
                        }
                        .padding(.horizontal)
                        
                        @State var isAuthenticated = false
                        NavigationLink(destination: Signup(isAuthenticated: $isAuthenticated)
                            .environmentObject(LogInVM())) {
                            Text("SKIP>")
                                .foregroundStyle(Color(hex: "CBC3E3"))
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                                .padding(.bottom, 30)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        //}
    }
}

struct WelcomePage3: View {
    var body: some View {
        //NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    HStack {
                        Text("Marketplace!")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color(hex:"CBC3E3"))
                    }
                    .padding()
                    
                    VStack {
                        Image("Welcome_Marketplace")
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
                        NavigationLink(destination: WelcomePage2()) {
                            Text("BACK")
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
                    
                    VStack {
                        NavigationLink(destination: WelcomePage4()) {
                            Text("NEXT")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .frame(height:50)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .background(Color("UIpurple"))
                            .cornerRadius(10)
                            
                        }
                        .padding(.horizontal)
                        
                        @State var isAuthenticated = false
                        NavigationLink(destination: Signup(isAuthenticated: $isAuthenticated)
                            .environmentObject(LogInVM())) {
                            Text("SKIP>")
                                .foregroundStyle(Color(hex: "CBC3E3"))
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                                .padding(.bottom, 30)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        //}
    }
}

struct WelcomePage4: View {
    var body: some View {
        //NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    HStack {
                        Text("Social Media!")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color(hex:"CBC3E3"))
                    }
                    .padding()

                    VStack {
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
                    .padding()

                    VStack {

                        NavigationLink(destination: WelcomePage3()) {
                            Text("BACK")
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
                    
                    VStack {
                        @State var isAuthenticated = false
                        NavigationLink(destination: Signup(isAuthenticated: $isAuthenticated)
                            .environmentObject(LogInVM())) {
                            Text("NEXT")
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
                    @State var isAuthenticated = false
                    NavigationLink(destination: Signup(isAuthenticated: $isAuthenticated)
                        .environmentObject(LogInVM())) {
                        Text("SKIP>")
                            .foregroundStyle(Color(hex: "CBC3E3"))
                            .fontWeight(.heavy)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 20)
                            .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        //}
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePage1()
            .navigationBarBackButtonHidden(true)
    }
}
