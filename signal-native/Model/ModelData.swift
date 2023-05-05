//
//  ModelData.swift
//  signal-native
//
//  Created by Jakub Bibro on 03/05/2023.
//

import Foundation
import OrderedCollections
import Combine

final class ModelData: ObservableObject {
    @Published var contacts: OrderedDictionary<Contact, Message> = [:]
    @Published var messages: OrderedDictionary<Contact, [Message]> = [
        Contact(name: "Ania"): [],
        Contact(name: "Miko"): [],
        Contact(name: "Jakub"): [],
    ]
    
    private let signal = Signal()
    var messageStream: AnyCancellable?
    
    init() {
        messageStream = signal.realMessages
            .merge(with: signal.messages())
            .receive(on: RunLoop.main)
            .sink { it in
                self.onMessage(msg: it)
            }
    }
    
    func onMessage(msg: (who: String, what: Message)) {
        let contact = Contact(name: msg.who)
        contacts[contact] = msg.what
        messages[contact]?.append(msg.what)
    }
}
