//
//  MessageView.swift
//  signal-native
//
//  Created by Jakub Bibro on 26/04/2023.
//

import SwiftUI



struct MessageView: View {
    let messages: [Message]

    @State private var message = ""

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(messages) {
                        ChatBubbleView(message: $0)
                            .padding(10)
                    }
                }
            }
            TextField(
                "Message",
                text: $message
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        }
        .background(Color(.controlBackgroundColor))
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(messages: [])
    }
}
