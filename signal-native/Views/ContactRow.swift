//
//  ContactRow.swift
//  signal-native
//
//  Created by Jakub Bibro on 26/04/2023.
//

import SwiftUI
import UserNotifications

struct ContactRow: View {
    let contactId: String
    let contactName: String
    let messages: [ChatMessage]
    let unreadMessages: Bool
        
    var body: some View {
        NavigationLink {
            ContactMessageView(messages: messages, contactId: contactId)
        } label: {
            HStack {
                PersonImageView(unreadMessages: unreadMessages)
                NameView(contactName: contactName)
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
    let contactName: String
    
    var body: some View {
        Text(contactName).font(.headline)
    }
}

struct ContactRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactRow(contactId: "1", contactName: "Jan", messages: [], unreadMessages: false)
    }
}
