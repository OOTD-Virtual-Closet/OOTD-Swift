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
    var tabImageNames : [String] = ["tshirt", "figure", "hand.thumbsup", "star"]
    var tabBarOptions: [String] = ["Clothes", "Outfits", "Recommended", "Favorites"]


    var body: some View {
        NavigationView {
            VStack{

                    
                VStack {
                    ZStack (alignment: .top) {
                        TabView(selection: self.$currentTab) {
                            ClothesView()
                                .tag(0)
                            OutfitsView()
                                .tag(1)
                            RecommendedView().tag(2)
                            FavoritesView().tag(3)

                        }.padding (.top, 50)
                        TabBarViewV2(currentTab: self.$currentTab, tabBarOptions: tabBarOptions, tabBarImages: tabImageNames,spacing: 30)
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
               
                Spacer()

                
            }

            
        }
    }
}

struct ClosetNav_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        ClosetNav(isAuthenticated: $isAuthenticated)
    }
}
