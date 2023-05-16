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
            
            Text(message.body)
                .foregroundColor(Color(message.direction == Direction.outgoing ? .white : .labelColor))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(message.direction == Direction.outgoing ? .systemBlue : .windowBackgroundColor))
                .cornerRadius(10)
            
            if message.direction == Direction.incoming {
                Spacer()
            }
        }
    }
}

struct ChatBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubbleView(message: ChatMessage(body: "a", direction: Direction.incoming))
    }
}
