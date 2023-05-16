//
//  Message.swift
//  signal-native
//
//  Created by Jakub Bibro on 03/05/2023.
//

import Foundation

struct ChatMessage: Identifiable { // todo opaque
    let id = UUID()
    let body: String
    let direction: Direction
    
    init(body: String, direction: Direction) {
        self.body = body
        self.direction = direction
    }
}

enum Direction {
    case incoming
    case outgoing
}
