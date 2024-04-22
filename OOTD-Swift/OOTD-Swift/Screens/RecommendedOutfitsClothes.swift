//
//  MarketNav.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/22/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage

@MainActor
final class ProfileViewModelRecClothes: ObservableObject {
    @Published var rec1: String = ""
    @Published var rec2: String = ""
    @Published var rec3: String = ""
    @Published var rec4: String = ""
    
    func GetAuthenticatedUser() throws -> AuthDataResultModel {
        let user = try AuthManager.shared.getAuthenticatedUser()
        return user
    }

    func getAlrOutfit() {
        
        var shoeList: [String] = []
        var pantList: [String] = []
        var jacketList: [String] = []
        var shirtList: [String] = []
        var outfitString: [String] = []

        
        //get all the clothes documents
        let db = Firestore.firestore()
        let collectionReference = db.collection("clothes")
        print("1")

        
        collectionReference.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                print("2")
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents found.")
                    print("3")
                    return
                }
                
                print("4")
                //add clothes URL to list for respective item
                for document in documents {
                    print("5")
                    print("Document ID: \(document.documentID)")
                    let pageData = document.data()
                    let imageData = pageData["image"] as! String
                    print("6")
                    let clothType = pageData["type"] as! String
                    print("7")
                    print("type: \(clothType)")
                    if clothType == "Jackets/Hoodies" {
                        jacketList.append(imageData)
                        print("jacket")
                    }
                    else if clothType == "Shoes" {
                        shoeList.append(imageData)
                        //self.rec2.loadImage(from: imageData)
                        print("shoes")
                    }
                    else if clothType == "Bottoms" {
                        pantList.append(imageData)
                        //self.rec3.loadImage(from: imageData)
                        print("bottoms")
                    }
                    else if clothType == "Tops" {
                        shirtList.append(imageData)
                        //self.rec4.loadImage(from: imageData)
                        print("tops")
                    }
                }
                
            }
        }
         
        print("8")

        
        //add clothes to final fit
        let num = Int.random(in: 0...jacketList.count-1)
        outfitString.append(jacketList[num])
        outfitString.append(shoeList[num])
        outfitString.append(pantList[num])
        outfitString.append(shirtList[num])
        
        
        for cloth in outfitString {
            let storageRef = Storage.storage().reference()
            let fileRef = storageRef.child(cloth)
            let num = 5 * 1024 * 1024
            fileRef.getData(maxSize: Int64(num)) { data, error in
                if error == nil && data != nil {
                    if let image = UIImage(data: data!) {
                        DispatchQueue.main.async {
                            finalOutfit.append(image)
                        }
                    }
                }
            }
        }
         
        
        self.rec1 = outfitString[0]
        self.rec2 = outfitString[1]
        self.rec3 = outfitString[2]
        self.rec4 = outfitString[3]
        print("13")
        print("end of func")
    }
    
}

struct RecommendedOutfitsClothes: View {
    @StateObject private var viewModelOutfit = ProfileViewModelRecClothes()
    @State private var selectedContent: Int? = 1
    @Binding var isAuthenticated:Bool
    var tabBarOptions: [String] = ["Categories", "Trending"]
    @State var currentTab: Int = 0

    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    
                    Text("Recommended")
                        .foregroundColor(.black)
                        .font(.system( size: 25))
                        .fontWeight(.heavy)
                        //.padding(.leading, 20)
                       .padding(.horizontal)
                }
                
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(hex: "E1DDED"))
                        .frame(width: 275, height: 310)
                        .overlay(
                            Group {
                                Image(viewModelOutfit.rec3)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .foregroundColor(Color(hex: "E1DDED"))
                                    .frame(width:90, height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .offset(x: -80, y: -80)
                                
                                Image(viewModelOutfit.rec2)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:90, height: 90)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .offset(x: -20, y: -5)
                                
                                Image(viewModelOutfit.rec1)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:90, height: 90)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .offset(x: 30, y: 50)
                                    
                                
                                Image(viewModelOutfit.rec4)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:90, height: 90)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .offset(x: 75, y: 95)
                            })
                }
                .onAppear {
                    do {
                        viewModelOutfit.getAlrOutfit()
                    }
                }
                .padding()
                              
                
                VStack {
                    
                        Button {
                            Task {
                                do {
                                   viewModelOutfit.getAlrOutfit()
                                }
                                
                            }
                        } label: {
                            HStack {
                                Text("Change Outfit")
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .frame(height:50)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .background(Color("UIpurple"))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        
                        
                    //TODO: CHANGE TO CALENDAR UI
                    @State var isAuthenticated = true
                    
                    NavigationLink(destination: DashboardNav(isAuthenticated: $isAuthenticated, userProfile: "im not adi")
                        .environmentObject(LogInVM())) {
                        Text("Go To Calendar")
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
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        }
    }


struct RecommendedOutfitsClothes_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        RecommendedOutfitsClothes(isAuthenticated: $isAuthenticated)
    }
}
