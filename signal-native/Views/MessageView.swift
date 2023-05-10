//
//  MessageView.swift
//  signal-native
//
//  Created by Jakub Bibro on 26/04/2023.
//

import SwiftUI



struct MessageView: View {
    let messages: [Message]
    @State var sentMessages: [Message] = []
    let contact: Contact

    @State private var message = ""
    @EnvironmentObject var messageService: Messages

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack {
                        ForEach(messages) {
                            ChatBubbleView(message: $0)
                                .padding(10)
                                .id($0.id)
                        }
                        .onChange(of: messages.count) { _ in
                            scrollView.scrollTo(messages.last?.id, anchor: .top)
                        }
                    }
                }
            }
            TextField(
                "Message",
                text: $message
            )
            .onSubmit {
                messageService.send(msg: message, contact: contact)
                message = ""
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        }
        .background(Color(.controlBackgroundColor))
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(messages: [], contact: Contact(name: "x", phoneNumber: "x"))
    }
}
