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
//                ("+123123123", ChatMessage(body: "co tam", direction: Direction.incoming)),

            ]
        )
        .merge(with: realMessages)
        .eraseToAnyPublisher()
    }
    
    func send(msg: String, reciepent: String) async -> Bool {
        var command: String
        if reciepent.starts(with: "+48") {
            command = "{\"jsonrpc\":\"2.0\",\"method\":\"send\",\"params\":{\"recipient\":[\"\(reciepent)\"],\"message\":\"\(msg)\"}}\n" // todo move to signal network
        } else {
            command = "{\"jsonrpc\":\"2.0\",\"method\":\"send\",\"params\":{\"groupId\":[\"\(reciepent)\"],\"message\":\"\(msg)\"}}\n" // todo move to signal network
        }
        let buffer = channel.allocator.buffer(string: command)
        do {
            try await channel.writeAndFlush(buffer).get()
            return true
        } catch {
            return false
        }
    }
}

