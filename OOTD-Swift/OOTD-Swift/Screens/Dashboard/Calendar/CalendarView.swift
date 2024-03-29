//
//  CalendarView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 3/24/24.
//

import SwiftUI

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

