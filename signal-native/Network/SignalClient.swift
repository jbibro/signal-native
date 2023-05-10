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

    func connect() -> Channel {
        let bootstrap = ClientBootstrap(group: group)
            .channelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .channelInitializer { channel in
                return channel.pipeline.addHandlers([ByteToMessageHandler(LineBasedFrameDecoder()), Handler(messages: messages)])
            }
        
        return try! bootstrap.connect(host: "::1", port: 7583).wait()
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
                if sent.sentMessage.groupInfo == nil {
                    messages.send((who: sent.sentMessage.destination, what: Message(body: sent.sentMessage.message, direction: Direction.outgoing)))
                }
            } else if let received = signalMessage.params.envelope.dataMessage {
                if received.groupInfo == nil { // ignore groups for now
                    messages.send((who: signalMessage.params.envelope.sourceNumber, what: Message(body: received.message, direction: Direction.incoming)))
                }
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
    var sourceNumber: String
    var syncMessage: SyncMessage?
    var dataMessage: DataMessage?
}

struct SyncMessage: Decodable {
    var sentMessage: SentMessage
}

struct DataMessage: Decodable {
    var message: String
    var groupInfo: GroupInfo?
}

struct SentMessage: Decodable {
    var message: String
    var destination: String
    var groupInfo: GroupInfo?
}

struct GroupInfo: Decodable {
    var groupId: String
    var type: String
}
