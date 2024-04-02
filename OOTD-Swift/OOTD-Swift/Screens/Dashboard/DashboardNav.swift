//
//  DashboardNav.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI

// If User logged IN --> View this --> Redirect to the 3 view panels
struct DashboardNav: View {
    @Binding var isAuthenticated:Bool
    @State private var selectedTab = 1
    @State private var stayLoggedInAlert = false
    let userProfile: String
    
    //ghetto code
    @State private var addPadding = true
    @State private var firstTimeOpening = true

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack{
                    NavigationLink(destination: CalendarView(addPadding: $addPadding)) {
                        Image("calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .padding(.leading)
                    }
                    Spacer()
                    Text(getTabName(for:selectedTab))
                        .foregroundColor(.black)
                        .font(.system( size: 25))
                        .fontWeight(.heavy)
                        .padding(.leading, 20)
                        .multilineTextAlignment(.center)
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
                switch selectedTab {
                case 1:
                    MarketNav(isAuthenticated: $isAuthenticated)
                case 2:
                    SocialNav(isAuthenticated: $isAuthenticated)
                case 3:
                    ClosetNav(isAuthenticated: $isAuthenticated)
                default:
                    SocialNav(isAuthenticated: $isAuthenticated)
                }
                
                Spacer()
                
                BottomNavBar(isAuthenticated: $isAuthenticated, selectedTab: $selectedTab)
                
                }
                .navigationBarHidden(true)
            }
            .ignoresSafeArea(.all)
            .if(addPadding) { view in
                view.padding(.top, -125)
            }
            .onAppear {
                self.confirmDocOnFirebase()
                if (UserDefaults.standard.bool(forKey: "staySignedIn") == false && firstTimeOpening == true) {
                    stayLoggedInAlert = true
                    firstTimeOpening = false
                }
            }
            .alert(isPresented: ($stayLoggedInAlert)) {
                Alert(
                    title: Text("Confirmation"),
                    message: Text("Do you want to stay signed in?"),
                    primaryButton: .default(Text("Yes")) {
                        UserDefaults.standard.set(true, forKey: "staySignedIn")
                    },
                    secondaryButton: .cancel(Text("No")) {
                        UserDefaults.standard.set(false, forKey: "staySignedIn")
                    }
                )
            }
        }
    
    func confirmDocOnFirebase() {
        let userViewModel = UserViewModel()
        
        print("View appeared!")
    }
    func getTabName (for value:Int) -> String {
        switch value {
        case 1:
            return "Marketplace"
        case 2:
            return "Social"
        case 3:
            return "Closet"
        default:
            return "Social"
        }
    }
}

struct DashboardNav_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        @State var selectedTab = 1
        DashboardNav(isAuthenticated: $isAuthenticated, userProfile: "im not adi")
            .environmentObject(LogInVM())
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
}
