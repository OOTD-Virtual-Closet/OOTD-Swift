//
//  DashboardNav.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

// If User logged IN --> View this --> Redirect to the 3 view panels
struct DashboardNav: View {
    @Binding var isAuthenticated:Bool
    @State private var selectedTab = 1
    @State private var stayLoggedInAlert = false
    let userProfile: String
    var uid = UserDefaults.standard.string(forKey: "uid") ?? "uid"
    @StateObject var imageLoader = ImageLoader() // Image load

    
    //ghetto code
    @State private var addPadding = true
    @State private var firstTimeOpening = true
    
    func fetchPFP(completion: @escaping () -> Void) {
       let docRef = Firestore.firestore().collection("users").document(uid)
       docRef.getDocument { document, error in
           if let document = document, document.exists {
               do {
                  let user = try document.data(as: User.self)
                   print("Cloth successfully fetched")
                   
                   if let imageUrl = user.name {
                       let storageRef = Storage.storage().reference()
                       storageRef.child(imageUrl).downloadURL { url, error in
                           if let url = url {
                               // Load image using image loader
                               imageLoader.loadImage(from: url)
                           } else if let error = error {
                               print("Error downloading image: \(error.localizedDescription)")
                           }
                           completion() // Call completion handler after fetching image
                       }
                   } else {
                       completion() // Call completion handler if image URL is nil
                   }
               } catch {
                   print("Error decoding user document: \(error.localizedDescription)")
                   completion() // Call completion handler if error occurs during decoding
               }
           } else {
               print("user document does not exist")
               completion() // Call completion handler if document does not exist
           }
       }
   }

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
                        if let image = imageLoader.image {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                .padding(.trailing)

                        } else {
                            Image("UserIcon") // Your user's profile picture
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                .padding(.trailing)
                        }
                            
                        
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
                fetchPFP {
                    print("")
                }
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
