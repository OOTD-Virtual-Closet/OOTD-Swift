//
//  TabUnderlineViews.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/25/24.
//

import SwiftUI

struct TabBarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    var spacing: CGFloat
    
    var tabBarOptions: [String] = ["Clothes", "Outfits"]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                ForEach(Array(zip(self.tabBarOptions.indices,
                                  self.tabBarOptions)),
                        id: \.0,
                        content: {
                    index, name in
                    TabBarItem(currentTab: self.$currentTab,
                               namespace: namespace.self,
                               tabBarItemName: name,
                               tab: index)
                    
                })
            }
            .padding(.horizontal)
        }
       .background(Color.white)
        .frame(height: 50)
    }
}

struct TabBarItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                Spacer()
                Text(tabBarItemName)             
                    .foregroundColor(.black)
                    .font(.system( size: 18))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                if currentTab == tab {
                    Color.black
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace,
                                               properties: .frame)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}

struct TabBarViewV2: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    
    var tabBarOptions: [String] 
    var tabBarImages: [String]
    var spacing: CGFloat
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                ForEach(Array(zip(self.tabBarOptions.indices,
                                  self.tabBarOptions)),
                        id: \.0,
                        content: {
                    index, name in
                    TabBarItemV2(currentTab: self.$currentTab,
                               namespace: namespace.self,
                               tabBarItemName: name,
                               tab: index, tabBarImageName: tabBarImages[index])
                    
                })
            }
            .padding(.horizontal)
        }
       .background(Color.white)
        .frame(height: 50)
    }
}

struct TabBarItemV2: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    
    var tabBarItemName: String
    var tab: Int
    var tabBarImageName: String
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                Spacer()
                HStack {
                    Text(tabBarItemName)
                    .foregroundColor(currentTab == tab ? .black : Color(hex: "9278E0"))
                    .font(.system(size:17))
                    .fontWeight(.heavy)
                Image(systemName: tabBarImageName)
                    .resizable()
                    .foregroundColor(currentTab == tab ? .black : Color(hex: "9278E0"))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 23, height: 23)
                    
                }

                if currentTab == tab {
                    Color.black
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace,
                                               properties: .frame)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}
