//
//  ChatRoomHeader.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 09/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct ChatRoomHeader: View {
    @ObservedObject var firebaseViewModel: FirebaseViewModel
    @State var chatRoomType: FirebaseChatRoomType
    var body: some View {
        HStack {
            Text("\(chatRoomType.rawValue.titleCase())")
                .font(.body)
            Spacer()
            if chatRoomType == .groupChat{
                Button(action: {
                    //                    self.firebaseViewModel.createChatRoom(chatRoomName: "Room 1") { (result) in
                    //                        switch result{
                    //                        case .success(let status):
                    //                            print("Status: \(status)")
                    //                        case .failure(let error):
                    //                            print("Chat room error \(error.localizedDescription)")
                    //                        }
                    //                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct ChatRoomHeader_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomHeader(firebaseViewModel: FirebaseViewModel(), chatRoomType: .individualChat)
    }
}
