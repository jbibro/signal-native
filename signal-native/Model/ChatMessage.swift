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
    let delivered: Bool
    
    init(body: String, direction: Direction) {
        self.body = body
        self.direction = direction
        self.delivered = true
    }
    
    init(body: String, direction: Direction, delivered: Bool) {
        self.body = body
        self.direction = direction
        self.delivered = delivered
    }
}

enum Direction {
    case incoming
    case outgoing
}
