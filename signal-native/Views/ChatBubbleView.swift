//
//  ChatBubbleView.swift
//  signal-native
//
//  Created by Jakub Bibro on 04/05/2023.
//

import SwiftUI

struct ChatBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.direction == Direction.outgoing {
                Spacer()
            }

            // todo design message when unable to send
            Text(message.body)
                .foregroundColor(Color(message.direction == Direction.outgoing ? .white : .labelColor))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(message.direction == Direction.outgoing ? .systemBlue : .windowBackgroundColor))
                .cornerRadius(10)
                .contextMenu {
                    Button {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(message.body, forType: .string)
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc.fill")
                    }
                }
            
            if message.direction == Direction.incoming {
                Spacer()
            }
        }
    }
}


struct GroupChatBubbleView: View {
    let message: ChatMessage
    
    @EnvironmentObject var contactService: ContactService

    var body: some View {
        HStack {
            if message.direction == Direction.outgoing {
                Spacer()
            }
            
            // todo design message when unable to send
            if message.direction == Direction.incoming {
                VStack(alignment: .leading) {
                    Text(contactService.contactNames[message.senderId!]!)
                        .foregroundColor(.purple)
                        .fontDesign(.rounded)
                        .padding(.top, 3)
                        .padding(.horizontal, 5)
                    
                    Text(message.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(.labelColor))
                        .padding(.horizontal, 5)
                        .padding(.bottom, 3)
                }
                .background(Color(message.direction == Direction.outgoing ? .systemBlue : .windowBackgroundColor))
                .cornerRadius(10)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                Spacer()
            } else {
                Text(message.body)
                    .foregroundColor(Color(.white))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .contextMenu {
                        Button {
                            // Add this item to a list of favorites.
                        } label: {
                            Label("Add to Favorites", systemImage: "heart")
                        }
                        Button {
                            // Open Maps and center it on this item.
                        } label: {
                            Label("Show in Maps", systemImage: "mappin")
                        }
                    }
            }
        }
    }
}

struct ChatBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubbleView(
            message: ChatMessage(
                body: "aawddqwd",
                recipientId: nil,
//                senderId: "+48123123123",
            )
        ).environmentObject(ContactService())
    }
}
