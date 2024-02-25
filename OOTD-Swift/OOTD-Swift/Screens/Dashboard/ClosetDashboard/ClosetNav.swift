//
//  ClosetNav.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/22/24.
//

import SwiftUI

struct ClosetNav: View {
    @State private var selectedContent: Int = 1
    @Binding var isAuthenticated:Bool
    @State var currentTab: Int = 0

    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack{
                HStack{
                    Spacer()
                    NavigationLink(destination: ProfileSummary(isAuthenticated: $isAuthenticated)) {
                        Image("UserIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .border(Color.gray)
                            .padding(.trailing)
                    }
                }
                Spacer()
                
            }
            VStack {
                Text("Closet")
                    .foregroundColor(.black)
                    .font(.system( size: 25))
                    .fontWeight(.heavy)
                ZStack (alignment: .top) {
                    TabView(selection: self.$currentTab) {
                        ClothesView()
                            .tag(0)
                        OutfitsView()
                            .tag(1)
                        FavoritesView().tag(2)

                    }.padding (.top, 50)
                  TabBarViewV2(currentTab: self.$currentTab)
                }
                
            //    HStack{
                    // Buttons to select content
                 //   Button(action: {
                  //      self.selectedContent = 1
//
                 //   }) {
                   //     Text("Clothes")
                    //        .foregroundColor(selectedContent == 1 ? //.black : Color(hex: "9278E0"))
                    //        .font(.system(size:17))
                   //         .fontWeight(.heavy)
                    //    Image(systemName: "tshirt")
                        //    .resizable()
                        //    .foregroundColor(selectedContent == 1 ? //.black : Color(hex: "9278E0"))
                       //     .aspectRatio(contentMode: .fit)
                        //    .frame(width: 23, height: 23)
                 //   }
                 //   Spacer()
                 //   Button(action: {
                 //       self.selectedContent = 2
                 //   }) {
                   //     Text("Outfits")
                   //         .foregroundColor(selectedContent == 2 ? .black : Color(hex: "9278E0"))
                    //        .font(.system(size:17))
                    //        .fontWeight(.heavy)
                  //      Image(systemName: "figure")
                     //       .resizable()
                     //       .foregroundColor(selectedContent == 2 ? .black : Color(hex: "9278E0"))
                     //       .aspectRatio(contentMode: .fit)
                     //       .frame(width: 23, height: 23)                    }
                  //  Spacer()
                  //  Button(action: {
                  //      self.selectedContent = 3
                  //  }) {
                  //      Text("Favorites")
                            //.foregroundColor(selectedContent == 3 ? .black : Color(hex: "9278E0"))
                         //   .font(.system(size:17))
                         //   .fontWeight(.heavy)
                      //  Image(systemName: "star")
                         //   .resizable()
                         //   .foregroundColor(selectedContent == 3 ? .black : Color(hex: "9278E0"))
                         //   .aspectRatio(contentMode: .fit)
                         //   .frame(width: 23, height: 23)
                   // }
                //}
              //  .padding(.horizontal, 20)

                Spacer()
                // Content views
             //   if selectedContent == 1 {
             //       ClothesView()
             //   } else if selectedContent == 2 {
              //      OutfitsView()
              //  } else if selectedContent == 3 {
               //     FavoritesView()
             //   }
              //  Spacer()
            }
            .padding(.bottom, -100)

            
        }
    }
}

struct ClosetNav_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        ClosetNav(isAuthenticated: $isAuthenticated)
    }
}
