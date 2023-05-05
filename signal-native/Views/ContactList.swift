//
//  ContactList.swift
//  signal-native
//
//  Created by Jakub Bibro on 26/04/2023.
//

import SwiftUI

struct ContactList: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        List {
            ForEach(modelData.contacts.elements, id: \.key) { key, value in
                ContactRow(name: key.name, messages: modelData.messages[Contact(name: key.name)] ?? [])
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
