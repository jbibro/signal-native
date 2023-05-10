//
//  ContactRow.swift
//  signal-native
//
//  Created by Jakub Bibro on 26/04/2023.
//

import SwiftUI

struct ContactRow: View {
    
    let contact: Contact
    let messages: [Message]
    
    var body: some View {
        NavigationLink {
            MessageView(messages: messages, contact: contact)
        } label: {
            HStack {
                PersonImageView()
                NameView(contact: contact)
            }
        }
    }
}

struct PersonImageView: View {
    var body: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 20, height: 20, alignment: .topLeading)
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
        ContactRow(contact: Contact(name: "Miko", phoneNumber: "111"), messages: [])
    }
}
