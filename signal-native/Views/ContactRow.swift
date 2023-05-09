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
            MessageView(messages: messages)
        } label: {
            HStack {
                PersonImageView()
                NameLastMessageTimeView(message: messages.last, contact: contact)
            }
        }
    }
}

struct LastMessageView: View {
    let message: Message
    
    var body: some View {
        Text(message.body)
            .font(.callout)
            .fontWeight(.light)
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

struct NameLastMessageTimeView: View {
    let message: Message?
    let contact: Contact
    
    var body: some View {
        VStack(alignment: .leading,spacing: 3) {
            HStack {
                Text(contact.name).font(.headline)
                Spacer()
                if let message = message {
                    Text("15:30").font(.callout)
                }
            }
            if let message = message {
                LastMessageView(message: message)
            }
        }
    }
}

struct ContactRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactRow(contact: Contact(name: "Miko"), messages: [])
    }
}
