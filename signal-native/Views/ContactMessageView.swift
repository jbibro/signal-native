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

    @EnvironmentObject var messageService: MessageService
    @Environment(\.controlActiveState) var controlActiveState

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
                            scrollView.scrollTo(messages.last?.id, anchor: .top) // extract
                        }
                        .onChange(of: messages.count) { it in
                            if controlActiveState == .key {
                                messageService.notifyReadAll(contactId: contactId)
                            }
                            scrollView.scrollTo(messages.last?.id, anchor: .top)
                        }
                        .onChange(of: controlActiveState) { newState in
                            if newState == .key {
                                messageService.notifyReadAll(contactId: contactId)
                            }
                        }
                    }
                    .padding(.top, 5)
                }
                .onAppear {
                    messageService.notifyReadAll(contactId: contactId)
                }
            }
            ChattingView(contactId: contactId)
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
