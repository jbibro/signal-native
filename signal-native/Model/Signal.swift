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
//        SignalClient(messages: realMessages).connect()
    }
    
    func messages() -> AnyPublisher<(who: String, what: Message), Never> {
        return Publishers.Sequence(sequence:
            [
                ("Ania", Message(body: "co tam", direction: Direction.incoming)),
                ("Ania", Message(body: "a nic", direction: Direction.outgoing)),
                ("Kuba", Message(body: "nudy", direction: Direction.incoming)),
                ("Kuba", Message(body: "nudy1", direction: Direction.outgoing)),
                ("Kuba", Message(body: "nudy2", direction: Direction.incoming)),
                ("Kuba", Message(body: "nudy3", direction: Direction.outgoing)),
                ("Kuba", Message(body: "nudy4", direction: Direction.incoming)),
                ("Ania", Message(body: "co tam", direction: Direction.incoming)),
                ("Ania", Message(body: "a nic", direction: Direction.outgoing)),
                ("Kuba", Message(body: "nudy", direction: Direction.incoming)),
                ("Kuba", Message(body: "nudy1", direction: Direction.outgoing)),
                ("Kuba", Message(body: "nudy2", direction: Direction.incoming)),
                ("Kuba", Message(body: "nudy3", direction: Direction.outgoing)),
                ("Kuba", Message(body: "nudy4", direction: Direction.incoming)),
            ]
        )
//        .merge(with: realMessages)
        .zip(Timer.publish(every: 0.2, on: RunLoop.main, in: .default).autoconnect())
        .map { it in it.0 }
        .eraseToAnyPublisher()
    }
}

