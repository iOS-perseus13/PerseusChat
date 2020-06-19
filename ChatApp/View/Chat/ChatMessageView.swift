////
////  ChatMessageView.swift
////  ChatApp
////
////  Created by Sheikh Ahmed on 19/06/2020.
////  Copyright © 2020 Perseus International. All rights reserved.
////
//
//import SwiftUI
//
//struct ChatMessageView: View {
//    @ObservedObject var firebaseViewModel: FirebaseViewModel
//    @State var message: FirebaseMessage
//    @State var values: [FirebaseUser] = [
//        .init(id: "id 1", email: "email1@email.com", name: "User 1", profileImage: nil),
//        .init(id: "id 2", email: "email2@email.com", name: "User 2", profileImage: "image 1"),
//        .init(id: "id 3", email: "email3@email.com", name: "User 3", profileImage: nil),
//        .init(id: "id 4", email: "email4@email.com", name: "User 4", profileImage: "image 2"),
//        .init(id: "id 5", email: "email5@email.com", name: "User 5", profileImage: "image 3"),
//        .init(id: "id 6", email: "email6@email.com", name: "User 6", profileImage: nil),
//    ]
//    var body: some View {
////        VStack{
////            // if its a group chat
////            message.roomId.map { chatRoom in
////                Text(chatRoom)
////            }
////            // if its individual chat
////            message.toUserId.map { toUser in
////                Text(toUser)
////            }
////        }
//
////        ForEach(self.values, id: \.self) { item in
////            item.profileImageURL.map{ image in
////                Image(systemName: "person")
////            }
//        }
//    }
//}
//
//struct ChatMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatMessageView(firebaseViewModel: FirebaseViewModel(), message: FirebaseMessage())
//    }
//}
