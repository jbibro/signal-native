//
//  Signal.swift
//  signal-native
//
//  Created by Jakub Bibro on 03/05/2023.
//

import Foundation
import Combine
import NIOCore

struct Signal {
    
    var realMessages = PassthroughSubject<(who: String, what: Message), Never>()
    var channel: Channel
    init() {
        channel = SignalClient(messages: realMessages).connect()
    }
    
    func messages() -> AnyPublisher<(who: String, what: Message), Never> {
        return Publishers.Sequence(sequence:
            [
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "co tam", direction: Direction.incoming)),
                ("+48669416529", Message(body: "KUBA!!!", direction: Direction.incoming)),
                ("+48669416529", Message(body: "a nic", direction: Direction.outgoing)),
                ("+48693985499", Message(body: "nudy", direction: Direction.outgoing)),
            ]
        )
        .merge(with: realMessages)
        .zip(Timer.publish(every: 0.2, on: RunLoop.main, in: .default).autoconnect())
        .map { it in it.0 }
        .eraseToAnyPublisher()
    }
    
    func send(msg: String, reciepent: String) {
        let s = "{\"jsonrpc\":\"2.0\",\"method\":\"send\",\"params\":{\"recipient\":[\"\(reciepent)\"],\"message\":\"\(msg)\"},\"id\":4}\n"
        let buffer = channel.allocator.buffer(string: s)
        channel.writeAndFlush(buffer)
        
        realMessages.send((who: reciepent, what: Message(body: msg, direction: Direction.outgoing)))
    }
}

