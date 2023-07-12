//
//  ModelData.swift
//  signal-native
//
//  Created by Jakub Bibro on 03/05/2023.
//

import Foundation
import OrderedCollections
import Combine
import UserNotifications

import AppKit
    
final class MessageService: ObservableObject {
    
    typealias ContactId = String
    
    private let contactService: ContactService
    private var signal: Signal

    @Published var chatMessages: OrderedDictionary<ContactId, [ChatMessage]> = [:]
    @Published var unreadMessages: [ContactId: Bool] = [:]
            
    var messageStream: AnyCancellable?
    
    init(signal: Signal, contactService: ContactService) {
        self.signal = signal
        self.contactService = contactService
        
        messageStream = signal.messages()
            .receive(on: RunLoop.main)
            .sink { self.onMessage(msg: $0) }
    }
    
    func onMessage(msg: Message) {
        switch msg {
        case .incoming(let from, let body, let groupId):
            guard let _ = contactService.contactNames[from] else {
                return
            }
            
            let contactId = groupId ?? from
            let chatMessage = ChatMessage(body: body, senderId: from, groupId: groupId)
            
            addMessage(contactId: contactId, message: chatMessage)
            notifyUnreadMessages(contactId: contactId)
        case .outgoingSentOnOtherDevice(let recipientId, let body, let groupId):
            let chatMessage = ChatMessage(body: body, recipientId: recipientId, groupId: groupId)
            let contactId = groupId ?? recipientId!
            addMessage(contactId: contactId, message: chatMessage)
        }

    }
    
    func chatMessages(contactId: String) -> [ChatMessage] {
        chatMessages[contactId] ?? []
    }
    
    func anyUnreadMessage(contactId: String) -> Bool {
        unreadMessages[contactId] ?? false
    }

    func send(msg: String, contactId: String) {
        Task {
            await self.signal.send(msg: msg, reciepent: contactId)
        }
        
        addMessage(contactId: contactId, message: ChatMessage(body: msg, recipientId: contactId, groupId: nil)) // todo update message when result comes
    }
    
    func notifyReadAll(contactId: String) {
        unreadMessages[contactId] = false
        
        updateBadge()
    }
    
    private func notifyUnreadMessages(contactId: String) {
        unreadMessages[contactId] = true
        
        updateBadge()
    }
    
    private func updateBadge() {
        let unreadMessages = unreadMessages.filter { $0.value }.count
        if unreadMessages > 0 {
            NSApplication.shared.dockTile.badgeLabel = String(unreadMessages)
        } else {
            NSApplication.shared.dockTile.badgeLabel = nil
        }
    }
    
    private func addMessage(contactId: String, message: ChatMessage) {
        if let _ = chatMessages[contactId] {
            chatMessages[contactId]!.append(message)
        } else {
            chatMessages[contactId] = [message]
        }
    }
}
