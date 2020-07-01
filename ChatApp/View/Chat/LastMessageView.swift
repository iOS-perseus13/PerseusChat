//
//  LastMessageView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 19/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI


struct LastMessageView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State var fromUser: FirebaseUser
    @State var toUser: FirebaseUser
    @State private var messages: [FirebaseMessage] = []
    var body: some View {
        HStack{
            if self.userViewModel.lastMessages.filter { message in
                message.fromUserId == self.toUser.id  &&
                    message.toUserId == self.fromUser.id
            }.sorted { (lhs, rhs) -> Bool in
                lhs.sequenceNumner > rhs.sequenceNumner
            }.isEmpty {
                Text(toUser.name)
            } else {
                self.userViewModel.lastMessages.filter { message in
                    message.fromUserId == self.toUser.id  &&
                        message.toUserId == self.fromUser.id
                }.sorted { (lhs, rhs) -> Bool in
                    lhs.sequenceNumner > rhs.sequenceNumner
                }.first.map {
                    message in
                    
                    HStack{
                        VStack{
                            /* Icon */
                            // if individual chat
                            userViewModel.getUser(userID: message.fromUserId).map {
                                user in
                                Image(systemName: "person")
                            }
                            // if group chat
                            userViewModel.getChatRoom(roomID: message.roomId).map {
                                room in
                                Image(systemName: "person.3")
                            }
                            .padding()
                        }
                        .frame(width: 75, height : 75)
                        .clipShape(Circle())
                        .overlay(Circle()
                        .stroke(Color.blue, lineWidth: 1)
                        )
                        VStack{
                            HStack{
                                // user name
                                userViewModel.getUser(userID: message.fromUserId).map{
                                    user in
                                    Text(user.name)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                }
                                // group name
                                userViewModel.getChatRoom(roomID: message.roomId).map{
                                    room in
                                    Text(room.name)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                }
                                Spacer()
                                //time
                                Text("\(message.createdTime.toLocalDate())")
                                    .font(.footnote)
                            }
                            HStack{
                                // read status
                                if message.toUserId != nil {
                                    Image(systemName: !message.readStatus ? "envelope" : "envelope.open")
                                        .foregroundColor(message.readStatus ? .blue : .none)
                                }
                                
                                Text(message.body)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                        }
                    }.padding()
                }
            }
            
        }
        .onAppear{
            self.messages = self.userViewModel.lastMessages.filter { message in
                message.fromUserId == self.toUser.id  &&
                    message.toUserId == self.fromUser.id
            }.sorted { (lhs, rhs) -> Bool in
                lhs.sequenceNumner > rhs.sequenceNumner
            }
        }
    }
}

