//
//  Message.swift
//  signal-native
//
//  Created by Jakub Bibro on 16/05/2023.
//

import Foundation

enum Message {
        
    typealias PhoneNumber = String
    
    struct IncomingMessage {
        let from: PhoneNumber
        let body: String
    }
    
    struct OutgoingMessageSentOnOtherDevice {
        let destination: PhoneNumber
        let body: String
    }
    
    case incoming(IncomingMessage)
    case outgoingSentOnOtherDevice(OutgoingMessageSentOnOtherDevice)
}
