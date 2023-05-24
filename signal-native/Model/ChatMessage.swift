//
//  Message.swift
//  signal-native
//
//  Created by Jakub Bibro on 03/05/2023.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let body: String
    let direction: Direction
    let senderId: String?
    let recipientId: String?
    let groupId: String?
    
    // I sent something (sync message)
    init(body: String, recipientId: String?, groupId: String?) {
        self.body = body
        self.direction = Direction.outgoing
        self.senderId = nil
        self.recipientId = recipientId
        self.groupId = groupId
    }
    
    // I received something
    init(body: String, senderId: String, groupId: String?) {
        self.body = body
        self.direction = Direction.incoming
        self.senderId = senderId
        self.recipientId = nil
        self.groupId = groupId
    }
}

enum Direction {
    case incoming
    case outgoing
}
