//
//  ContactList.swift
//  signal-native
//
//  Created by Jakub Bibro on 26/04/2023.
//

import SwiftUI

struct ContactList: View {
    
    @EnvironmentObject var contacts: Contacts
    @EnvironmentObject var messages: Messages
    
    var body: some View {
        List {
            Section(header: Text("Direct Messages")) {
                ForEach(contacts.contacts.keys) {
                    ContactRow(contact: $0, messages: messages.messages[Contact(name: $0.name)] ?? [])
                }
            }
            Section(header: Text("Groups")) {
                ContactRow(contact: Contact(name: "Frania"), messages: [])
                ContactRow(contact: Contact(name: "Gotowanie"), messages: [Message(body: "zdjecie obiadu", direction: Direction.incoming)])
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
