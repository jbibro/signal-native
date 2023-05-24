//
//  MessageView.swift
//  signal-native
//
//  Created by Jakub Bibro on 26/04/2023.
//

import SwiftUI



struct ContactMessageView: View {
    var messages: [ChatMessage] = []
    let contactId: String

    @State private var message = ""
    @EnvironmentObject var messageService: MessageService

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack {
                        ForEach(messages) {
                            if let _ = $0.groupId{
                                GroupChatBubbleView(message: $0)
                                    .padding(.horizontal, 5)
                                    .id($0.id)
                            } else {
                                ChatBubbleView(message: $0)
                                    .padding(.horizontal, 5)
                                    .id($0.id)
                            }
                        }
                        .onAppear() {
                            messageService.notifyReadAll(contactId: contactId)
                            scrollView.scrollTo(messages.last?.id, anchor: .top) // extract
                        }
                        .onChange(of: messages.count) { it in
                            scrollView.scrollTo(messages.last?.id, anchor: .top)
                        }
                    }
                    .padding(.top, 5)
                }
            }
            TextField(
                "Message",
                text: $message
            )
            .onSubmit {
                messageService.send(msg: message, contactId: contactId)
                message = ""
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        }
        .background(Color(.controlBackgroundColor))
    }
}

struct MessageView_Previews: PreviewProvider {
    @State static var readMessages: Int = 0
    
    static var previews: some View {
        ContactMessageView(messages: [], contactId: "123")
    }
}
