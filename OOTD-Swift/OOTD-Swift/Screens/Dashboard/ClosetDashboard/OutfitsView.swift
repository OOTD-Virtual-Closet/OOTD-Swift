//
//  OutfitsView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct OutfitsView: View {
    @State var expandedOutfitsPresented = false
    @State var expandedFitChosen : Outfit?
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



    let items = (1...10).map { "Item \($0)" }
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var addOutfitsPresented = false
    
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
                    TextField("", text: $searchText, onEditingChanged: { editing in
                        isEditing = editing
                    })
                    .padding(.leading, 30)
                    .frame(width: UIScreen.main.bounds.width - 90, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(hex: "E1DDED"))
                            .padding(.leading, 15)
                    )
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .foregroundColor(.black)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .padding(.leading, 27)
                            Text("Search...")
                                .foregroundColor(.black)
                                .font(.system(size: 17))
                                .fontWeight(.heavy)
                                .padding(.leading, 5)
                            Spacer()
                        }
                            .opacity(isEditing || !searchText.isEmpty ? 0 : 1)
                    )
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
                            ForEach(outfits ?? [], id: \.self) { item in
                                Button(action: {
                                    expandedOutfitsPresented.toggle()
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
            Button(action: {
                addOutfitsPresented.toggle()
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                        .background(Color(hex: "E1DDED"))
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .padding(.trailing, 20)
                }
            }
            .sheet(isPresented: $expandedOutfitsPresented, onDismiss: {
                populateOutfits {
                    print("Arrays are updated again")
                }
            }) {
     
                 if let expandedFitChosen = expandedFitChosen {
                    ExpandedOutfitsView(mainOutfit: expandedFitChosen)
                }
            }

            .padding(.bottom, 50)
            .sheet(isPresented: $addOutfitsPresented,onDismiss: {
                populateOutfits {
                    print("Arrays are updated")
                }
            }
            ) {
                AddOutfit()
            }
        }
        .onAppear {
            populateOutfits {
                print("populated outfits for outfitview")
            }
        }
    }
}

struct Outfits: View {
    let item: String
    @State var outfit: Outfit? // Cloth object fetched from Fire
    
    @StateObject var imageLoader = ImageLoader() // Image load
    @StateObject var imageLoader2 = ImageLoader() // Image load
    @StateObject var imageLoader3 = ImageLoader() // Image load
    @StateObject var imageLoader4 = ImageLoader()
    
    func fetchOutfitFromFirestore(completion: @escaping () -> Void) {
        let docRef = Firestore.firestore().collection("outfits").document(item)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                do {
                    outfit = try document.data(as: Outfit.self)
                    print("Outfit successfully fetched")
                    
                    let cloths = [outfit?.cloth1, outfit?.cloth2, outfit?.cloth3, outfit?.cloth4].compactMap { $0 }
                    for (index, clothID) in cloths.enumerated() {
                        let counter = index + 1
                        let clothDocRef = Firestore.firestore().collection("clothes").document(clothID)
                        clothDocRef.getDocument { clothDocument, clothError in
                            if let clothDocument = clothDocument, clothDocument.exists {
                                do {
                                    let cloth = try clothDocument.data(as: Cloth.self)
                                    if let imageUrl = cloth.image {
                                        let storageRef = Storage.storage().reference()
                                        storageRef.child(imageUrl).downloadURL { url, error in
                                            if let url = url {
                                                switch counter {
                                                case 1:
                                                    imageLoader.loadImage(from: url)
                                                case 2:
                                                    imageLoader2.loadImage(from: url)
                                                case 3:
                                                    imageLoader3.loadImage(from: url)
                                                case 4:
                                                    imageLoader4.loadImage(from: url)
                                                default:
                                                    break
                                                }
                                            } else if let error = error {
                                                print("Error downloading image: \(error.localizedDescription)")
                                            }
                                        }
                                    }
                                } catch {
                                    print("Error decoding cloth document: \(error.localizedDescription)")
                                }
                            } else {
                                print("Cloth document \(clothID) does not exist")
                            }
                        }
                    }
                    completion() // Call completion handler after fetching images
                } catch {
                    print("Error decoding outfit document: \(error.localizedDescription)")
                    completion() // Call completion handler if error occurs during decoding
                }
            } else {
                print("Outfit document does not exist")
                completion() // Call completion handler if document does not exist
            }
        }
    }

    
    var body: some View {


            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(hex: "E1DDED"))
                    .frame(width: 170, height: 250)
                    .overlay(
                            Group {
                                   if let image = imageLoader.image {
                                      Image(uiImage: image)
                                             .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .foregroundColor(Color(hex: "E1DDED"))
                                            .frame(width:70, height: 70)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .offset(x: -50, y: -50)

                                       if let image2 = imageLoader2.image {
                                                   Image(uiImage: image2)
                                                       .resizable()
                                                       .aspectRatio(contentMode: .fill)
                                                       .frame(width:70, height: 70)
                                                       .clipShape(RoundedRectangle(cornerRadius: 10))
                                                       .offset(x: -20, y: -20)
                                               }
                                       if let image3 = imageLoader3.image {
                                                   Image(uiImage: image3)
                                                       .resizable()
                                                       .aspectRatio(contentMode: .fill)
                                                       .frame(width:70, height: 70)
                                                       .clipShape(RoundedRectangle(cornerRadius: 10))
                                                       .offset(x: 10, y: 10)
                                               }
                                       if let image4 = imageLoader4.image {
                                                   Image(uiImage: image4)
                                                       .resizable()
                                                       .aspectRatio(contentMode: .fill)
                                                       .frame(width:70, height: 70)
                                                       .clipShape(RoundedRectangle(cornerRadius: 10))
                                                       .offset(x: 40, y: 40)
                                               }
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color(hex: "E1DDED"))
                                        .frame(width: 170, height: 250)
                                        .overlay(
                                            Text("loading...")
                                                .foregroundColor(.white)
                                                .font(.headline)
                                    )
                                }
                              }
                    )
                Text(outfit?.name ?? "Name")
                    .foregroundColor(.black)
                    .font(.system(size: 12))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                Text("Last Worn 3/1/2024")
                    .foregroundColor(.gray)
                    .font(.system(size: 9))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
            }
            .onAppear {
                fetchOutfitFromFirestore {
                    print("fetched outfit and stuff")
                }
            }
    }
}

//struct OutfitsView_Previews: PreviewProvider {
  //  static var previews: some View {
  //      OutfitsView()
  //  }
//}
