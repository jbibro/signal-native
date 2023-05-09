//
//  Contacts.swift
//  signal-native
//
//  Created by Jakub Bibro on 05/05/2023.
//

import Foundation
import OrderedCollections
import Combine

class Contacts: ObservableObject {
    @Published var contacts: OrderedDictionary<Contact, Message> = [:]
    
    private let signal: Signal
    var messageStream: AnyCancellable?

    init(signal: Signal) {
        self.signal = signal
        messageStream = signal
            .messages()
            .receive(on: RunLoop.main)
            .sink { m in self.updateLastMessage(contact: Contact(name: m.who), message: Message(body: m.what.body, direction: m.what.direction)) }
    }
    
    func updateLastMessage(contact: Contact, message: Message) {
        contacts[contact] = message
    }
}
