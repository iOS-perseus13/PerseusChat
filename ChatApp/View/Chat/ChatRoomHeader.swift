//
//  ChatRoomHeader.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 19/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct ChatRoomHeader: View {
    @ObservedObject var userViewModel: UserViewModel
    @State var chatRoomType: FirebaseChatRoomType
    var body: some View {
        HStack {
            Text("\(chatRoomType.rawValue.titleCase())")
                .font(.body)
            Spacer()
            if chatRoomType == .groupChat{
                Button(action: {
                    // action ...
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
            }
        }
    }
}
