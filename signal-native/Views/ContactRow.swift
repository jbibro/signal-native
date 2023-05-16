//
//  ContactRow.swift
//  signal-native
//
//  Created by Jakub Bibro on 26/04/2023.
//

import SwiftUI
import UserNotifications

struct ContactRow: View {
    let contact: Contact
    let messages: [ChatMessage]
    let unreadMessages: Bool
        
    var body: some View {
        NavigationLink {
            ContactMessageView(messages: messages, contact: contact)
        } label: {
            HStack {
                PersonImageView(unreadMessages: unreadMessages)
                NameView(contact: contact)
            }
        }
        
    }
}

struct PersonImageView: View {
    
    let unreadMessages: Bool
    
    var body: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 20, height: 20, alignment: .topLeading)
            .foregroundStyle(unreadMessages ? .green : .primary)
    }
}

struct NameView: View {
    let contact: Contact
    
    var body: some View {
        Text(contact.name).font(.headline)
    }
}

struct ContactRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactRow(contact: Contact(name: "Miko", phoneNumber: "111"), messages: [], unreadMessages: false)
    }
}
