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
                
                ForEach(contactService.contactNames.keys) { // todo fix
                    ContactRow(contactId: $0, contactName: contactService.contactNames[$0]!, messages: messageService.chatMessages(contactId: $0), unreadMessages: messageService.anyUnreadMessage(contactId: $0))
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
