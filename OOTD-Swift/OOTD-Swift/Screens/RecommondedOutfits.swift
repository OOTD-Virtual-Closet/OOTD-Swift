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
final class ProfileViewModelRecOutfits: ObservableObject {
    @Published var rec1: String = ""
    @Published var rec2: String = ""
    @Published var rec3: String = ""
    @Published var rec4: String = ""
    
    func GetAuthenticatedUser() throws -> AuthDataResultModel {
        let user = try AuthManager.shared.getAuthenticatedUser()
        return user
    }

    func getOutfit() {
        /*
        var shoeList: [String] = []
        var pantList: [String] = []
        var jacketList: [String] = []
        var shirtList: [String] = []
        var outfitString: [String] = []
        */
        
        var shoeList: [String] = ["472FB35E-AA9E-421F-BB93-E2DB86175650", "6693DF00-B342-46D1-BF0E-31BB2568B9DB", "8E8659F6-1724-44B1-B35E-B76C873A0C97", "9B6ECE60-64EE-4B07-A94B-22D8CD6DFA12"]
        var pantList: [String] = ["06D78F37-455A-4559-A7D3-A01A34BC411F", "176A1BC5-E2AA-4601-8A2C-C2A2E4055C1D", "99F6C329-26C5-4475-BA3C-E49DF0ED3EBA", "E3639166-F996-4312-9ADF-9802D68B20E1"]
        var jacketList: [String] = ["7BEC2D96-EE4F-40A8-AA57-7A88A9397463", "D0425C28-88A3-4187-B4FC-38FD59BF00B8", "AFB4DB24-C0FD-4332-BF26-100EC37BE3E6", "32860CC7-8C2F-4E52-9747-5085DDF9BCF6"]
        var shirtList: [String] = ["F229C603-7175-4A61-929E-E46B72C5EFAB", "A6164EFB-5A4D-46DB-9DE5-49FDDDD52EE3", "A6CDA725-6BF5-493F-B2A5-AF03A1C484F3", "BE40F1B7-25B6-44A3-8629-7362FE2ECCC9", "1B65307F-031B-4C87-9E79-E70C6D665DA7", "21E9F05E-4A22-4C97-BCB2-25C69BE7203D"]
        var outfitString: [String] = []
        
        
        //get all the clothes documents
        let db = Firestore.firestore()
        let collectionReference = db.collection("clothes")
        print("1")

        /*
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
         */
        print("8")
        
        //add clothes to final fit
        
        if (jacketList.count > 0) {
            let jacketNum = Int.random(in: 0...jacketList.count-1)
            outfitString.append(jacketList[jacketNum])
            print("9")
            //self.rec1 = jacketList[jacketNum]
        } else {
            print("jacket < 0")
        }
        
        if (shoeList.count > 0) {
            let shoeNum = Int.random(in: 0...shoeList.count-1)
            outfitString.append(shoeList[shoeNum])
            print("10")
            //self.rec2 = shoeList[shoeNum]
        } else {
            print("shoe < 0")
        }
        
        if (pantList.count > 0) {
            let pantNum = Int.random(in: 0...pantList.count-1)
            outfitString.append(pantList[pantNum])
            print("11")
            //self.rec3 = pantList[pantNum]
        } else {
            print("pant < 0")
        }
        
        if (shirtList.count > 0) {
            let shirtNum = Int.random(in: 0...shirtList.count-1)
            outfitString.append(shirtList[shirtNum])
            print("12")
            //self.rec4 = shirtList[shirtNum]
        } else {
            print("shirt < 0")
        }

        /*
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
         */
        
        self.rec1 = outfitString[0]
        self.rec2 = outfitString[1]
        self.rec3 = outfitString[2]
        self.rec4 = outfitString[3]
        print("13")
        print("end of func")
    }
    
}

struct RecommendedOutfits: View {
    @StateObject private var viewModelOutfit = ProfileViewModelRecOutfits()
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
                        .padding(.leading, 20)
                        .padding(.horizontal)
                }
                
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(hex: "E1DDED"))
                        .frame(width: 275, height: 310)
                        .overlay(
                            Group {
                                Image(viewModelOutfit.rec1)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .foregroundColor(Color(hex: "E1DDED"))
                                    .frame(width:90, height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .offset(x: -80, y: -80)
                                
                                Image(viewModelOutfit.rec4)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:90, height: 90)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .offset(x: -20, y: -5)
                                
                                Image(viewModelOutfit.rec3)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:90, height: 90)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .offset(x: 30, y: 50)
                                    
                                
                                Image(viewModelOutfit.rec2)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:90, height: 90)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .offset(x: 75, y: 95)
                            })
                }
                .onAppear {
                    do {
                        viewModelOutfit.getOutfit()
                    }
                }
                .padding()
                
                              
                
                VStack {
                    
                        Button {
                            Task {
                                do {
                                   viewModelOutfit.getOutfit()
                                }
                                
                            }
                        } label: {
                            HStack {
                                Text("New Outfit")
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
                        
                        
                    NavigationLink(destination: OutfitsView()) {
                        Text("Go To Closet")
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


struct RecommendedOutfits_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        RecommendedOutfits(isAuthenticated: $isAuthenticated)
    }
}
