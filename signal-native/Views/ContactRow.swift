//
//  ContactRow.swift
//  signal-native
//
//  Created by Jakub Bibro on 26/04/2023.
//

import SwiftUI

struct ContactRow: View {
    
    let name: String
    let messages: [Message]
    
    var body: some View {
        NavigationLink {
            MessageView(messages: messages)
        } label: {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20, alignment: .topLeading)
                VStack(
                    alignment: .leading,
                    spacing: 3
                ) {
                    HStack {
                        Text(name)
                            .font(.headline)
                        Spacer()
                        Text("15:30")
                            .font(.callout)
                    }
                    Text(messages.last?.body ?? "")
                        .font(.callout)
                        .fontWeight(.light)
                }
            }
        }
    }
}

struct ContactRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactRow(name: "Miko", messages: [])
    }
}
