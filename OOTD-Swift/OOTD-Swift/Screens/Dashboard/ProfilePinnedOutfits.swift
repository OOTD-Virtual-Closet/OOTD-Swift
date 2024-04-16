//
//  ProfilePinnedOutfits.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 4/15/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct ProfilePinnedOutfits: View {
    @State private var outfits : [Outfit]?
    var uid = UserDefaults.standard.string(forKey: "uid") ?? "uid"

    private func populateOutfits(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("User document does not exist")
                return
            }
            
            if let outfitsData = document.data()?["outfits"] as? [String] {
                print("here you go", outfitsData)
                var loadedOutfits = [Outfit]()
                let dispatchGroup = DispatchGroup()
                
                for outfitID in outfitsData {
                    dispatchGroup.enter()
                    
                    let outfitRef = db.collection("outfits").document(outfitID)
                    outfitRef.getDocument { outfitDocument, outfitError in
                        defer {
                            dispatchGroup.leave()
                        }
                        
                        if let outfitDocument = outfitDocument, outfitDocument.exists {
                            do {
                                if let outfitData = outfitDocument.data() {
                                    let name = outfitData["name"] as? String ?? ""
                                    let genre = outfitData["genre"] as? String ?? ""
                                    let cloth1 = outfitData["cloth1"] as? String ?? ""
                                    let cloth2 = outfitData["cloth2"] as? String ?? ""
                                    let cloth3 = outfitData["cloth3"] as? String ?? ""
                                    let cloth4 = outfitData["cloth4"] as? String ?? ""
                                    
                                    let outfit = Outfit(id: outfitID, name: name, genre: genre, cloth1: cloth1, cloth2: cloth2, cloth3: cloth3, cloth4: cloth4)
                                    loadedOutfits.append(outfit)
                                    print("Loaded outfit successfully")
                                } else {
                                    print("Outfit document \(outfitID) does not contain data")
                                }
                            } catch {
                                print("Error decoding outfit document \(outfitID): \(error.localizedDescription)")
                            }
                        } else {
                            print("Outfit document \(outfitID) does not exist")
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self.outfits = loadedOutfits
                    print("Outfits loaded)")
                    completion()
                }
            } else {
                print("No outfits data found")
            }
        }
    }
    @State var expandedFitChosen : Outfit?

    
    @State private var test = false;

    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Text("0 Items")
                        .foregroundColor(.gray)
                        .font(.system( size: 13))
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 15)
                        .padding(.top, 5)
                    Text("Your Outfits")
                        .foregroundColor(.black)
                        .font(.system( size: 25))
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 15)

                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
                            ForEach(outfits ?? [], id: \.self) { item in
                                Button(action: {
                                    expandedFitChosen = item
                                }) {
                                    Outfits(item: item.id)
                                    .frame(width: 170, height: 280)
                                }
                            }
                        }
                        .padding(15)
                        .padding(.vertical, 20)
                    }
                    
                }
            }
        }
        .onAppear {
            populateOutfits {
                print("populated outfits for outfitview")
            }
        }
    }
}

