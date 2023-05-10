//
//  ModelData.swift
//  signal-native
//
//  Created by Jakub Bibro on 03/05/2023.
//

import Foundation
import OrderedCollections
import Combine

final class Messages: ObservableObject {
    @Published var messages: OrderedDictionary<Contact, [Message]> = [:]
    private let contacts = Contacts()
    
    private var signal: Signal
    var messageStream: AnyCancellable?
    
    init(signal: Signal) {
        self.signal = signal
        messageStream = signal.messages()
            .receive(on: RunLoop.main)
            .sink { self.onMessage(msg: $0) }
    }
    
    func onMessage(msg: (who: String, what: Message)) {
        let contact = contacts[msg.who]!
        if messages.keys.contains(contact) {
            messages[contact]!.append(msg.what)
        } else {
            messages[contact] = [msg.what]
        }
    }
    
    func send(msg: String, contact: Contact) {
        signal.send(msg: msg, reciepent: contact.phoneNumber)
    }
}
