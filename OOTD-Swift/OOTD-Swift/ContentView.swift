//
//  ContentView.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/8/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            if checkQuickLogin() {
                // TODO: Implement quick login
            } else if checkBiometricLogin() {
                // TODO: Implement biometric login
            } else {
                
            }
        }
    }
    
    //checks if quick login is enabled
    private func checkQuickLogin() {
    }

    //checks if biometric login is enabled
    //returns true/false
    private func checkBiometricLogin() {
        
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
