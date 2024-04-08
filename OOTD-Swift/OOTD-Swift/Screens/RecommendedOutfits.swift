

import SwiftUI

struct RecommendedOutfits: View {
    @State private var selectedContent: Int? = 1
    @Binding var isAuthenticated:Bool
    var tabBarOptions: [String] = ["Categories", "Trending"]
    @State var currentTab: Int = 0

    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Spacer()
                    Text("Recommended")
                        .foregroundColor(.black)
                        .font(.system( size: 25))
                        .fontWeight(.heavy)
                        .padding(.leading, 20)
                    Spacer()
                    NavigationLink(destination: ProfileSummary(isAuthenticated: $isAuthenticated)) {
                        Image("UserIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            .padding(.trailing)
                    }
                }
                
                VStack {
                    ZStack (alignment: .top) {
                        TabView(selection: self.$currentTab) {
                            CategoriesView()
                                .tag(0)
                           TrendingView().tag(1)
                            
                        }.padding (.top, 50)
                        
                    }
                    Spacer()
                }
                .padding(.bottom, -100)
                
            }

            }
        }
    }


struct RecommendedOutfits_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAuthenticated = true
        RecommendedOutfits(isAuthenticated: $isAuthenticated)
    }
}
