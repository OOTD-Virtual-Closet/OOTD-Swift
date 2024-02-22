//
//  SplashScreen.swift
//  OOTD-Swift
//
//  Created by Atharva Gupta on 2/21/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive == true {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        } else {
            VStack {
                VStack {
                    Image(.appLogo)
                        .resizable()
                        .frame(width: 450, height: 200)
                    Text("Outfit. Of. The. Day")
                        .font(.system(size: 26))
                        .foregroundColor(.black.opacity(0.8))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
