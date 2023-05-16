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
    
    @StateObject private var contacts: ContactService
    @StateObject private var messages: MessageService
    init() {
        let signal = Signal()
        let contactService = ContactService()
        let messageService = MessageService(signal: signal, contactService: contactService)
        
        _contacts = StateObject(wrappedValue: contactService)
        _messages = StateObject(wrappedValue: messageService)
    }
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contacts)
                .environmentObject(messages)
        }
    }
}
