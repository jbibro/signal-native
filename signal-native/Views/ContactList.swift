//
//  ContactList.swift
//  signal-native
//
//  Created by Jakub Bibro on 26/04/2023.
//

import SwiftUI

struct ContactList: View {
    
    @EnvironmentObject var contactService: ContactService
    @EnvironmentObject var messageService: MessageService

    var body: some View {
        List {
            Section(header: Text("Direct Messages")) {
                ForEach(contactService.contacts()) {
                    ContactRow(contact: $0, messages: messageService.chatMessages(contact: $0), unreadMessages: messageService.anyUnreadMessage(contact: $0))
                }
            }
            Section(header: Text("Groups")) {
            }
        }
        .navigationTitle("Contacts")
        .listStyle(SidebarListStyle())
        .padding(.vertical)
    }
}

struct ContactList_Previews: PreviewProvider {
    static var previews: some View {
        ContactList()
    }
}
