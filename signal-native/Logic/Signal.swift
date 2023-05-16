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
    
    var realMessages = PassthroughSubject<Message, Never>()
    var channel: Channel
    init() {
        channel = SignalClient(messages: realMessages).connect()
    }
    
    func messages() -> AnyPublisher<Message, Never> {
        return Publishers.Sequence(sequence:
            [
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "co tam", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "KUBA!!!", direction: Direction.incoming)),
//                ("+48669416529", ChatMessage(body: "a nic", direction: Direction.outgoing)),
//                ("+48693985499", ChatMessage(body: "nudy", direction: Direction.outgoing)),
            ]
        )
        .merge(with: realMessages)
        .eraseToAnyPublisher()
    }
    
    func send(msg: String, reciepent: String) {
        let s = "{\"jsonrpc\":\"2.0\",\"method\":\"send\",\"params\":{\"recipient\":[\"\(reciepent)\"],\"message\":\"\(msg)\"}}\n"
        let buffer = channel.allocator.buffer(string: s)
        try! channel.writeAndFlush(buffer).wait() // todo doczytac
    }
}

