//
//  MessageView.swift
//  signal-native
//
//  Created by Jakub Bibro on 26/04/2023.
//

import SwiftUI



struct ContactMessageView: View {
    var messages: [ChatMessage] = []
    let contact: Contact

    @State private var message = ""
    @EnvironmentObject var messageService: MessageService

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack {
                        ForEach(messages) {
                            ChatBubbleView(message: $0)
                                .padding(.horizontal, 5)
                                .id($0.id)
                        }
                        .onAppear() {
                            messageService.notifyReadAll(contact: contact)
                            scrollView.scrollTo(messages.last?.id, anchor: .top)
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
                Task {
                    await messageService.send(msg: message, contact: contact)
                    message = ""
                }
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
        ContactMessageView(messages: [], contact: Contact(name: "x", phoneNumber: "x"))
    }
}
