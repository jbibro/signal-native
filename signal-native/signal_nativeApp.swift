//
//  signal_nativeApp.swift
//  signal-native
//
//  Created by Jakub Bibro on 26/04/2023.
//

import SwiftUI
import Combine

@main
struct signal_nativeApp: App {
    
    @StateObject private var contacts: Contacts
    @StateObject private var messages: Messages
    init() {
        let signal = Signal()
        _contacts = StateObject(wrappedValue: Contacts(signal: signal))
        _messages = StateObject(wrappedValue: Messages(signal: signal))
    }
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contacts)
                .environmentObject(messages)
        }
    }
}
