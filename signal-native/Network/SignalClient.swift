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
    var messages: PassthroughSubject<Message, Never>

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
    var messages: PassthroughSubject<Message, Never>

    init(messages: PassthroughSubject<Message, Never>) {
        self.messages = messages
    }
    
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let buffer = self.unwrapInboundIn(data)
        let data: Data? = String(buffer: buffer).data(using: .utf8)
        print(String(buffer: buffer))
        do {
            let message = try jsonDecoder.decode(SignalMessage.self, from: data!).toMessage()
            if let msg = message {
                messages.send(msg)
            }

        } catch {
            
        }
    }
}

struct SignalMessage: Decodable {
    var params: Params
    
    func toMessage() -> Message? {
        if let sent = params.envelope.syncMessage {
            if sent.sentMessage.groupInfo == nil {
                return Message.outgoingSentOnOtherDevice(Message.OutgoingMessageSentOnOtherDevice(destination: sent.sentMessage.destination, body: sent.sentMessage.message))
            }
        } else if let received = params.envelope.dataMessage {
            if received.groupInfo == nil { // ignore groups for now
                return Message.incoming(Message.IncomingMessage(from: params.envelope.sourceNumber, body: received.message))
            }
        }
        return nil
    }
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
