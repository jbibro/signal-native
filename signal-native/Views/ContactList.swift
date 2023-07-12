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
        
        List() {
            Section(header: Text("Direct Messages")) {
                
                ForEach(contactService.contactNames.keys) { contactId in
                    ContactRow(
                        contactId: contactId,
                        contactName: contactService.contactNames[contactId]!,
                        messages: messageService.chatMessages(contactId: contactId),
                        unreadMessages: messageService.anyUnreadMessage(contactId: contactId)
                    )
                    .tag(contactId)
                }
            }
//            Section(header: Text("Groups")) {
//                ForEach(contactService.groups()) {
//                    ContactRow(contact: Contact(name: $0.name, phoneNumber: "asd"), messages: [], unreadMessages: false)
//                }
//            }
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
