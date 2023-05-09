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
    @Published var messages: OrderedDictionary<Contact, [Message]> = [
        Contact(name: "Aniusia 😍"): [],
        Contact(name: "Miko"): [],
        Contact(name: "Kuba"): [],
        Contact(name: "Jakub"): []
    ]
    
    private var signal: Signal
    var messageStream: AnyCancellable?
    
    init(signal: Signal) {
        self.signal = signal
        messageStream = signal.messages()
            .receive(on: RunLoop.main)
            .sink { self.onMessage(msg: $0) }
    }
    
    func onMessage(msg: (who: String, what: Message)) {
        let contact = Contact(name: msg.who)
        messages[contact]?.append(msg.what)
    }
}
