//
//  FavoriteClothes.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/25/24.
//

import FirebaseFirestore
import FirebaseStorage
import SwiftUI


struct FavoriteClothes: View {
    
    @State private var expandedClothesPresented = false;
    @State private var expandedClothesChosen : Cloth?

    @State private var tops : [Cloth]?
    @State private var bottoms : [Cloth]?
    @State private var jackets : [Cloth]?
    @State private var shoes : [Cloth]?
    var uid = UserDefaults.standard.string(forKey: "uid") ?? "uid"

    private func populateArrays(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let clothes = document.data()?["favorites"] as? [String] {
                    var loadedCloths = [Cloth]()
                    let dispatchGroup = DispatchGroup()
                    
                    for item in clothes {
                        dispatchGroup.enter()
                        
                        let docRef = db.collection("clothes").document(item)
                        docRef.getDocument { document, error in
                            defer {
                                dispatchGroup.leave()
                            }
                            if let document = document, document.exists {
                                do {
                                    let cloth =  try document.data(as: Cloth.self)
                                        loadedCloths.append(cloth)
                                    
                                } catch {
                                    print("Error decoding cloth document: \(error.localizedDescription)")
                                }
                            } else {
                                print("Cloth document does not exist")
                            }
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        tops = loadedCloths.filter { $0.type == "Tops" }
                        bottoms = loadedCloths.filter { $0.type == "Bottoms" }
                        jackets = loadedCloths.filter { $0.type == "Jackets/Hoodies" }
                        shoes = loadedCloths.filter { $0.type == "Shoes" }
                        
                        completion()
                    }
                }
            } else {
                print("User document does not exist")
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Tops")
                        .foregroundColor(.black)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.leading, 15)
                        .padding(.top, 20)
                    Text("\(tops?.count ?? 0)")
                        .foregroundColor(.gray)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.top, 20)
                    Spacer()
                }
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(tops ?? [], id: \.self) { view in
                            Button(action: {
                                expandedClothesPresented.toggle()
                                expandedClothesChosen = view
                                
                            }) {
                                Clothes(item: view.id)
                                    .frame(width: 112, height: 140)
                                
                            }
                        }
                    }.padding(10)
                }
                .padding(.trailing, 15)
                
                
                HStack {
                    Text("Hoodies & Jackets")
                        .foregroundColor(.black)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.leading, 15)
                        .padding(.top, 20)
                    Text("\(jackets?.count ?? 0)")
                        .foregroundColor(.gray)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.top, 20)
                    Spacer()
                }
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(jackets ?? [], id: \.self) { view in
                            Button(action: {
                                expandedClothesPresented.toggle()
                                expandedClothesChosen = view
                                
                            }) {
                                
                                Clothes(item: view.id)
                                    .frame(width: 112, height: 140)
                                
                            }
                        }
                    }.padding(10)
                }.padding(.trailing, 15)
                HStack {
                    Text("Pants")
                        .foregroundColor(.black)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.leading, 15)
                        .padding(.top, 20)
                    Text("\(bottoms?.count ?? 0)")
                        .foregroundColor(.gray)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.top, 20)
                    Spacer()
                }
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(bottoms ?? [], id: \.self) { view in
                            Button(action: {
                                expandedClothesPresented.toggle()
                                expandedClothesChosen = view
                                
                            }) {
                                
                                Clothes(item: view.id)
                                    .frame(width: 112, height: 140)
                                
                            }
                        }
                    }.padding(10)
                }
                .padding(.trailing, 15)
                HStack {
                    Text("Shoes")
                        .foregroundColor(.black)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.leading, 15)
                        .padding(.top, 20)
                    Text("\(shoes?.count ?? 0)")
                        .foregroundColor(.gray)
                        .font(.system( size: 20))
                        .fontWeight(.heavy)
                        .padding(.top, 20)
                    Spacer()
                }
                //                        ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(shoes ?? [], id: \.self) { view in
                        Button(action: {
                            expandedClothesPresented.toggle()
                            expandedClothesChosen = view
                            
                        }) {
                            
                            Clothes(item: view.id)
                                .frame(width: 112, height: 140)
                        }
                    }
                }
                .sheet(isPresented: $expandedClothesPresented, onDismiss: {
                    populateArrays {
                        print("Arrays are updated again")
                    }
                }) {
                    
                    if let expandedClothesChosen = expandedClothesChosen {
                        ExpandedClothesView(mainClothe: expandedClothesChosen)
                    }
                }
                .padding(10)
                .onAppear {
                    populateArrays {
                        print("Arrays are updated")
                    }
                    Color.white
                        .frame(width: UIScreen.main.bounds.width, height: 100)
                    
                }
            }
            .padding(.top, 40)
            .ignoresSafeArea(.all)
        }
        
    }
}




