//
//  CalendarViewModel.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 3/24/24.
//

import Foundation
import Firebase
import FirebaseFirestore


class CalendarViewModel: ObservableObject {
    let db = Firestore.firestore()
    var uid = UserDefaults.standard.string(forKey: "uid") ?? "uid"
    @Published var isPresented = false
    @Published var outfits : [Outfit]?
    @Published var outfitOptions =  ["None"]
    @Published var plans : [String: Any]?

    func addPostToCurrentUser() {
        
    }
    func fetchPosts() {
        
    }
    func getStartMonth() {
        
    }
    func getMonthArray() {
        
    }
    func getOutfitPlan() {
        let docRef = db.collection("users").document(uid)

        Task {
            do {
              let document = try await docRef.getDocument()
              if document.exists {
                  let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                  DispatchQueue.main.async {
                      print()
                      let plans: [String: String] = document.data()?["plans"] as! [String : String]
                      self.plans = plans
                  }
              } else {
                print("Document does not exist")
              }
            } catch {
              print("Error getting document: \(error)")
            }
        }
    }
    func editOutfitPlan(date: String, outfitID: String) {
        let docRef = db.collection("users").document(uid)
        self.plans?[date] = outfitID
        print("plans are here adi")
        print(self.plans)
        Task {
            do {
                // Update one field, creating the document if it does not exist.
                try await db.collection("users").document(uid).setData([ "plans": plans ?? ["date":"plan"]], merge: true)
            }
        }
    }
    func printOutfits() {
        if let outfitsTemp = outfits {
            for outfit in outfitsTemp {
                print(outfit.name)
            }
        }

    }
    func getOutfits(completion: @escaping () -> Void) {
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
                    
                    let outfitRef = self.db.collection("outfits").document(outfitID)
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
                    self.outfitOptions = ["None"]
                    for outfit in loadedOutfits {
                        self.outfitOptions.append(outfit.name)
                    }
                    print("Outfits loaded)")
                    self.printOutfits()
                    completion()
                }
            } else {
                print("No outfits data found")
            }
        }

    }
}
struct MonthModel:Identifiable {
    var id:String = ""
    var month:String = ""
    var monthOfTheYear:Int = 0
    var year:Int = 0
    var amountOfDays:Int {
        let dateComponents = DateComponents(year: year, month: monthOfTheYear)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    var spacesBeforeFirst:Int {
        let dateComponents = DateComponents(year: year, month: monthOfTheYear)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        return date.dayNumberOfWeek()!
    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
