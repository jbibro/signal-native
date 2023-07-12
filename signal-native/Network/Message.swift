//
//  Message.swift
//  signal-native
//
//  Created by Jakub Bibro on 16/05/2023.
//

import Foundation

enum Message {
            
    case incoming(from: String, body: String, groupId: String? = nil)
    case outgoingSentOnOtherDevice(recipientId: String?, body: String, groupId: String? = nil)
}
