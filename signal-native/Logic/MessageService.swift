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

    @Published var chatMessages: OrderedDictionary<Contact, [ChatMessage]>
    @Published var unreadMessages: [Contact: Bool] = [:]
        
    var messageStream: AnyCancellable?
    
    init(signal: Signal, contactService: ContactService) {
        self.signal = signal
        self.contactService = contactService
        self.chatMessages = contactService.contacts().reduce(into: OrderedDictionary<Contact, [ChatMessage]>()) { result, contact in result[contact] = [] }
        
        
        messageStream = signal.messages()
            .receive(on: RunLoop.main)
            .sink { self.onMessage(msg: $0) }
    }
    
    func onMessage(msg: Message) {
        switch msg {
        case .incoming(let incomingMessage):
            guard let contact = contactService[incomingMessage.from] else {
                return
            }
            addToChatMessages(contact: contact, msg: ChatMessage(body: incomingMessage.body, direction: Direction.incoming))
            notifyUnreadMessages(contact: contact) // but only if app is in background
        case .outgoingSentOnOtherDevice(let outgoing):
            guard let contact = contactService[outgoing.destination] else {
                return
            }
            addToChatMessages(contact: contact, msg: ChatMessage(body: outgoing.body, direction: Direction.outgoing))
        }
    }
    
    func addToChatMessages(contact: Contact, msg: ChatMessage) {
        chatMessages[contact]?.append(msg)
    }
    
    func chatMessages(contact: Contact) -> [ChatMessage] {
        return chatMessages[contact] ?? []
    }
    
    func anyUnreadMessage(contact: Contact) -> Bool {
        return unreadMessages[contact] ?? false
    }
        
    func send(msg: String, contact: Contact) {
        signal.send(msg: msg, reciepent: contact.phoneNumber)
        addToChatMessages(contact: contact, msg: ChatMessage(body: msg, direction: Direction.outgoing))
    }
    
    func notifyReadAll(contact: Contact) {
        unreadMessages[contact] = false
        
        updateBadge()
    }
    
    func notifyUnreadMessages(contact: Contact) {
        unreadMessages[contact] = true
        
        updateBadge()
    }
    
    func updateBadge() {
        UNUserNotificationCenter.current().setBadgeCount(unreadMessages.filter { $0.value }.count)
    }
}
