//
//  ContentView.swift
//  signal-native
//
//  Created by Jakub Bibro on 26/04/2023.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
            
    var body: some View {
        NavigationView {
            ContactList()
        }
        .navigationTitle("Signal Native")
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: .badge)
                             { (_, _) in }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
