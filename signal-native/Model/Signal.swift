//
//  Signal.swift
//  signal-native
//
//  Created by Jakub Bibro on 03/05/2023.
//

import Foundation
import Combine

struct Signal {
    
    var realMessages = PassthroughSubject<(who: String, what: Message), Never>()
    
    init() {
        SignalClient(messages: realMessages).connect()
    }
    
    func messages() -> AnyPublisher<(who: String, what: Message), Never> {
        return Publishers.Sequence(sequence:
            [
                ("Ania", Message(body: "co tam", direction: Direction.incoming)),
                ("Ania", Message(body: "a nic", direction: Direction.outgoing)),
                ("Miko", Message(body: "nudy", direction: Direction.incoming))
            ]
        )
        .zip(Timer.publish(every: 0.5, on: RunLoop.main, in: .default).autoconnect())
        .map { it in it.0 }
        .eraseToAnyPublisher()
    }
}

