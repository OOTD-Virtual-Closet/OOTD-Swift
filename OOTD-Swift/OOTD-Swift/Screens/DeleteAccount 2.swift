//
//  DeleteAccount.swift
//  OOTD-Swift
//
//  Created by Sanjhee Gupta on 2/16/24.
////
//
//import SwiftUI
//
//struct DeleteAccount: View {
//    @State private var showSignInView: Bool = false
//    @Binding var isAuthenticated:Bool
//
//    
//    var body: some View {
//        ZStack {
//            NavigationStack {
//                Text("Temporary Screen (just testing login auth)")
//                ProfileSummary(showSignInView: $showSignInView)
//            }
//        }
//        .onAppear {
//            let authUser = try? AuthManager.shared.getAuthenticatedUser()
//            self.showSignInView = authUser == nil
//            isAuthenticated = false
//        }
//    }
//}
//
//struct Previews_DeleteAccount_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var isAuthenticated = true
//        DeleteAccount(isAuthenticated: $isAuthenticated)
//    }
//}
