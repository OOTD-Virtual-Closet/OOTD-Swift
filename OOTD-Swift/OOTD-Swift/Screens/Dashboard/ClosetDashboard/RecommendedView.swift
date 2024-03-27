//
//  TrendingView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI
import FirebaseFirestore

struct RecommendedView: View {
    @State private var currentIndex = 0
    @State private var isExpanded = false
    var uid = UserDefaults.standard.string(forKey: "uid") ?? "uid"

    @State var outfits: [Outfit]?
    
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
                    outfits = loadedOutfits
                    print("Outfits loaded)")
                    completion()
                }
            } else {
                print("No outfits data found")
            }
        }
    }

    
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
        .onAppear {
            populateOutfits {
                print("it worked probably")
            }
        }
    }
}
