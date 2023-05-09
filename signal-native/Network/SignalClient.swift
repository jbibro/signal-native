//
//  SignalClient.swift
//  signal-native
//
//  Created by Jakub Bibro on 04/05/2023.
//

import Foundation
import NIOPosix
import NIOCore
import NIOExtras
import Combine

struct SignalClient {
    private let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    var messages: PassthroughSubject<(who: String, what: Message), Never>

    func connect() {
        let bootstrap = ClientBootstrap(group: group)
            .channelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .channelInitializer { channel in
                return channel.pipeline.addHandlers([ByteToMessageHandler(LineBasedFrameDecoder()), Handler(messages: messages)])
            }
        
        try! bootstrap.connect(host: "::1", port: 7583).wait()
    }
    
    func disconnect() {
        
    }
}

class Handler: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer
    private let jsonDecoder = JSONDecoder()
    var messages: PassthroughSubject<(who: String, what: Message), Never>

    init(messages: PassthroughSubject<(who: String, what: Message), Never>) {
        self.messages = messages
    }
    
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let buffer = self.unwrapInboundIn(data)
        let data: Data? = String(buffer: buffer).data(using: .utf8)
        print(String(buffer: buffer))
        do {
            let signalMessage = try jsonDecoder.decode(SignalMessage.self, from: data!)
            if let sent = signalMessage.params.envelope.syncMessage {
                messages.send((who: signalMessage.params.envelope.sourceName, what: Message(body: sent.sentMessage.message, direction: Direction.outgoing)))
            } else if let received = signalMessage.params.envelope.dataMessage {
                messages.send((who: signalMessage.params.envelope.sourceName, what: Message(body: received.message, direction: Direction.incoming)))
            }
        } catch {
            
        }
    }
}

struct SignalMessage: Decodable {
    var params: Params
}

struct Params: Decodable {
    var envelope: Envelope
}

struct Envelope: Decodable {
    var sourceName: String
    var syncMessage: SyncMessage?
    var dataMessage: DataMessage?
}

struct SyncMessage: Decodable {
    var sentMessage: SentMessage
}

struct DataMessage: Decodable {
    var message: String
}

struct SentMessage: Decodable {
    var message: String
    var destination: String
}
