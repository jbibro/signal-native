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
    
final class MessageService: ObservableObject {
    private let contactService: ContactService
    private var signal: Signal

    @Published var chatMessages: OrderedDictionary<String, [ChatMessage]> = [:]
    @Published var unreadMessages: [String: Bool] = [:]
        
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
            guard let _ = contactService[from] else {
                return
            }
            
            let chatMessage = ChatMessage(body: body, senderId: from, groupId: groupId)
            if let groupId = groupId {
                addMessage(contactId: groupId, message: chatMessage)
                notifyUnreadMessages(contactId: groupId) 
            } else {
                addMessage(contactId: from, message: chatMessage)
                notifyUnreadMessages(contactId: from)
            }
        case .outgoingSentOnOtherDevice(let contactId, let body, let groupId):
            let chatMessage = ChatMessage(body: body, recipientId: contactId, groupId: groupId)
            if let groupId = groupId {
                addMessage(contactId: groupId, message: chatMessage)
            } else if let contactId = contactId {
                addMessage(contactId: contactId, message: chatMessage)
            }
        case .groups(let groups):
            groups.filter { ["Frania", "Gotowanie", "Test"].contains($0.name) }.forEach { contactService.contactNames[$0.id] = $0.name }
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
        UNUserNotificationCenter.current().setBadgeCount(unreadMessages.filter { $0.value }.count)
    }
    
    private func addMessage(contactId: String, message: ChatMessage) {
        if let existingContact = chatMessages[contactId] {
            chatMessages[contactId]!.append(message)
        } else {
            chatMessages[contactId] = [message]
        }
    }
}
