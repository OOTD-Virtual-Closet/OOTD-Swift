//
//  CalendarView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 3/24/24.
//

import SwiftUI

struct CalendarView: View {

    @State var todayDate = Date()
    @State var startDate: Date = Date()
    @State var months = [MonthModel(id: "id", month: "December", monthOfTheYear: 12, year: 2022), MonthModel(id: "id2", month: "January", monthOfTheYear: 1, year: 2023), MonthModel(id: "id3", month: "February", monthOfTheYear: 2, year: 2023)] // on appear, calculate all months in between dec 2022 - today

    @Environment(\.presentationMode) var mode
    @StateObject var viewModel = CalendarViewModel()

    private var daysOfTheWeek = ["Sun", "Mon", "Tue", "Wed", "Thurs", "Fri", "Sat"]
    private var columns = [
        GridItem.init(.flexible(), alignment: .center),
        GridItem.init(.flexible(), alignment: .center),
        GridItem.init(.flexible(), alignment: .center),
        GridItem.init(.flexible(), alignment: .center),
        GridItem.init(.flexible(), alignment: .center),
        GridItem.init(.flexible(), alignment: .center),
        GridItem.init(.flexible(), alignment: .center)
    ]
    private func get30DaysAgo() -> Date {
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
                        
                        CalendarCell(beforeImageURL: "", afterImageURL: "", date: "", height: UIScreen.main.bounds.width/6.5, dayOfMonth: i)
                        
                    }
                    
                }
                .padding(.horizontal)
            }
            .padding(.top, 75)
            
        }
        .navigationBarHidden(true)
        .overlay(
            VStack(spacing: 15) {
                Text("Progress")
                    .font(.headline)
                    .padding(.top, 7)
                VStack {
                    HStack(spacing: 0) {
                        Spacer()
                        ForEach(daysOfTheWeek, id: \.self) { d in
                            Text(d)
                            Spacer()
                        }
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
                }
            }
            , alignment: .top
        )
        .overlay(
            Button {
                mode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "arrow.backward")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(10)
            }
            .padding(.leading)
            
            , alignment: .topLeading
        )
        .overlay(
            VStack {
                LinearGradient(colors: [.clear, .black.opacity(0.3), .black.opacity(0.7)], startPoint: .bottom, endPoint: .top)
                    .frame(height: UIScreen.main.bounds.height/12)
                Spacer()
            }
            .ignoresSafeArea()
        )
        .onAppear {
            viewModel.fetchPosts()
        }
    }

}

struct CalendarView_Previews: PreviewProvider { static var previews: some View { CalendarView() } }

    struct CalendarCell: View {

    var beforeImageURL:String
    var afterImageURL:String
    var date:String
    var height:CGFloat
    var dayOfMonth:Int

    @State var showSheet:Bool = false

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
        .sheet(isPresented: $showSheet) {
            //
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
