//
//  MessageDetailView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 19/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct MessageDetailView: View {
    @State var message: FirebaseMessage
    @State var isOwnMessage: Bool
    @State var senderImage: UIImage?
    @State var receiverImage: UIImage?
    var body: some View {
        HStack {
            Image(uiImage: (isOwnMessage ? self.senderImage : self.receiverImage) ?? UIImage())
            if isOwnMessage {
                Spacer()
            }
            VStack(alignment: isOwnMessage ? .trailing : .leading ) {
                Text("\(message.createdTime.toLocalDate())")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(isOwnMessage ? Color.blue : Color.primary)
                Text(message.body)
                    .foregroundColor(isOwnMessage ? Color.blue : Color.primary)
            }
            if !isOwnMessage {
                Spacer()
            }
            
        }
    }
}
