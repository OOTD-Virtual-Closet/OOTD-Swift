//
//  CalendarView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 3/24/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import PhotosUI
import UIKit

struct CalendarView: View {
    @Binding var addPadding: Bool

    @State private var todayDate = Date()
    @State private var startDate: Date = Date()
    @State private var months = [MonthModel(id: "id", month: "March", monthOfTheYear: 3, year: 2024), MonthModel(id: "id2", month: "April", monthOfTheYear: 4, year: 2024), MonthModel(id: "id3", month: "May", monthOfTheYear: 5, year: 2024)] // on appear, calculate all months

    @StateObject private var viewModel = CalendarViewModel()
    

    var daysOfTheWeek = ["Sun", "Mon", "Tue", "Wed", "Thurs", "Fri", "Sat"]
    var columns = [
        GridItem.init(.flexible(), alignment: .center),
        GridItem.init(.flexible(), alignment: .center),
        GridItem.init(.flexible(), alignment: .center),
        GridItem.init(.flexible(), alignment: .center),
        GridItem.init(.flexible(), alignment: .center),
        GridItem.init(.flexible(), alignment: .center),
        GridItem.init(.flexible(), alignment: .center)
    ]
    func get30DaysAgo() -> Date {
        // Get the current calendar
        var calendar = Calendar.current
        
        // Get the current date
        let currentDate = Date()
        
        // Subtract 30 days from the current date
        if let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: currentDate) {
            return thirtyDaysAgo
        } else {
            // Handle error if unable to calculate the date
            fatalError("Unable to calculate 30 days ago.")
        }
    }
    

    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            // Amount of months since December 2022
            ForEach(months) { month in
                
                Text("\(month.month) \(month.year)")
                    .font(.caption.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                
                LazyVGrid(columns: columns, alignment: .center, pinnedViews: .sectionHeaders) {
                    
                    ForEach(1..<month.spacesBeforeFirst) { _ in
                        Text("")
                    }
                    
                    // Days in a month
                    ForEach(1..<month.amountOfDays + 1) { i in
                        CalendarCell(addPadding:$addPadding, beforeImageURL: "", afterImageURL: "", date: "\(month.year) \(month.month) \(i)", height: UIScreen.main.bounds.width/6.5, dayOfMonth: i, viewModel: viewModel)
                    }
                    
                }
                .padding(.horizontal)
            }
            .padding(.top, 75)
            
        }
        .navigationBarTitle("Calendar", displayMode: .inline)
        .overlay( // days of the week at the top
            VStack(spacing: 30) {
                VStack() {
                    HStack(spacing: 0) {
                        Spacer()
                        ForEach(daysOfTheWeek, id: \.self) { d in
                            Text(d)
                            Spacer()
                        }
                    }
                    .padding(.top, 10)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
                }
            }
            , alignment: .top
        )
        .overlay( // gradient at the top of the screen
            VStack {
                LinearGradient(colors: [.clear, .black.opacity(0.3), .black.opacity(0.7)], startPoint: .bottom, endPoint: .top)
                    .frame(height: UIScreen.main.bounds.height/12)
                Spacer()
            }
            .ignoresSafeArea()
        ) // fetch posts on appear fo
        .onAppear {
            print("getting outfits")
            viewModel.getOutfits {
                print("got outfits")
            }
            viewModel.getOutfitPlan()
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View { Text("hey") }
}

struct CalendarCell: View {
    @Binding var addPadding: Bool

    var beforeImageURL:String
    var afterImageURL:String
    var date:String
    var height:CGFloat
    var dayOfMonth:Int
    
    @State private var selectedOutfit : String?
    @State var showSheet:Bool = false
    @ObservedObject var viewModel : CalendarViewModel
    @State var selectedImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    
    func getImage() -> UIImage? {
            let uiImage = UIImage(named: "shirt")
            return uiImage
        }
    
    
    func uploadImage() -> String {
        if selectedImage == nil  {
            selectedImage = getImage()
            print("Image not selected in calendarview!")
        }
        
        //create storage reference
        let storageRef = Storage.storage().reference()
        
        // turn image into data (please work)
        let imageData = selectedImage!.pngData()
        
        guard imageData != nil else {
            print("failed")
            return ""
        }
        // specify filepath and name
        let path = "daily/\(UUID().uuidString).png"
        let fileRef = storageRef.child(path)
        
        // Upload dis data
        if let selectedImage = selectedImage {
            let resizedImage = selectedImage.resizedImageWithinRect(rectSize: CGSize(width: 200, height: 200)) //check size stuff after
            if let imageData = resizedImage.jpegData(compressionQuality: 0.75) {
                let uploadTask = fileRef.putData(imageData, metadata: nil) {
                    metadata, error in
                    
                    if error == nil && metadata != nil {
                        print("Successfully stored image")
                    }
                    else {
                        print("failed storing image")
                    }
                }
            }
        }
        return path
    }

    var body: some View {
        
        Button {
            showSheet = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray)
                    .frame(height: height)
                Text(dayOfMonth.description)
                    .foregroundColor(.white)
                    .font(.headline)
                    .shadow(radius: 3)
            }
        }
        .sheet(isPresented: $showSheet, onDismiss: {
            print(selectedOutfit ?? "None")
            viewModel.editOutfitPlan(date: date, outfitID: selectedOutfit ?? "None")
        }) {
            
            VStack {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height: UIScreen.main.bounds.height / 7)
                    .ignoresSafeArea(.all)
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                        .padding(.bottom, 20)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(hex: "E1DDED"))
                        .frame(width: 220, height: 220)
                        .padding(.bottom, 20)
                        .overlay(
                    Text("Upload Image Below")
                        .foregroundColor(.black)
                        .font(.system( size: 20))
                        )
                }
                PhotosPicker(selection: $photosPickerItem, label: {
                    Image(systemName: "square.and.arrow.up.circle.fill")
                        .resizable()
                        .foregroundColor(Color(hex: "9278E0"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .padding(.bottom, 20)
                })
                .onChange(of: photosPickerItem) {  _ in
                    Task{
                        if let photosPickerItem,
                           let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                            if let image = UIImage(data:data) {
                                selectedImage = image
                            }
                        }
                        var path = uploadImage()
                    }
                }
                CustomDropDown(title: "Planned Outfit", prompt: "Select an Outfit for this day", options: viewModel.outfitOptions, selection: $selectedOutfit)
                    .onAppear {
                        addPadding = false
                        print(date)
                        viewModel.getOutfitPlan()
                        if let plans = viewModel.plans {
                            selectedOutfit = plans[date]
                        }
                        print("adi get the plan")
                        print(viewModel.plans?[date] ?? "no plan for \(date)")
                    }
            }

        }
    }
}
