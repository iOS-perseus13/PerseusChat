//
//  ChatRoomView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 06/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct ChatRoomView: View {
    @ObservedObject var firebaseViewModel: FirebaseViewModel
    @State var users: [FirebaseUser] = []
    var body: some View {
        Form {
            Section(
                header: GroupChatHeader(firebaseViewModel: self.firebaseViewModel, chatRoomType: .groupChat)
            ) {
                List {
                    ForEach(self.firebaseViewModel.chatRooms, id: \.self) { chatRoom in
                        Text("Name: \(chatRoom.name), Id: \(chatRoom.id), Admin: \(chatRoom.admin)")
                    }
                }
            }
            Section(
                header: GroupChatHeader(firebaseViewModel: self.firebaseViewModel, chatRoomType: .individualChat)
            ) {
                List{
                    ForEach(self.firebaseViewModel.users, id: \.self){ item in
                        Text(item.name)
                    }
                }
                
            }
        }.padding()
    }
}

struct ChatRoomView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomView(firebaseViewModel: FirebaseViewModel())
    }
}

struct GroupChatHeader: View {
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

struct GroupChatRowView: View {
    @State var lastMessage: FirebaseMessage
    var body: some View{
        HStack{
            // group icon
            Image(systemName: "bubble.left.and.bubble.right")
            VStack {
                HStack{
                    Text("Group name")
                    Text(lastMessage.fromUserId)
                    Spacer()
                    Text("\(lastMessage.createdTime)")
                }
                Text(lastMessage.body)
            }
        }
    }
}
