//
//  LastMessageView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 09/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct LastMessageView: View {
    @ObservedObject var firebaseViewModel: FirebaseViewModel
    @State var lastMessage: FirebaseMessage?
    var body: some View {
        HStack{
            if lastMessage != nil {
                VStack{
                    /* Icon */
                    // if individual chat
                    firebaseViewModel.getUser(userID: lastMessage!.fromUserId).map {
                        user in
                        Image(systemName: "person")
                    }
                    // if group chat
                    firebaseViewModel.getChatRoom(roomID: lastMessage!.roomId).map {
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
                        firebaseViewModel.getUser(userID: lastMessage!.fromUserId).map{
                            user in
                            Text(user.name)
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }
                        // group name
                        firebaseViewModel.getChatRoom(roomID: lastMessage!.roomId).map{
                            room in
                            Text(room.name)
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        //time
                        Text("\(lastMessage!.createdTime.toLocalDate())")
                            .font(.footnote)
                    }
                    HStack{
                        // read status
                        if lastMessage!.toUserId != nil {
                            Image(systemName: !lastMessage!.readStatus ? "envelope.open" : "envelope")
                                .foregroundColor(lastMessage!.readStatus ? .blue : .none)
                        }
                        
                        Text(lastMessage!.body)
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }.padding()
            }
        }
    }
}


struct LastMessageView_Previews: PreviewProvider {
    static var previews: some View {
        LastMessageView(firebaseViewModel: FirebaseViewModel(), lastMessage: FirebaseMessage(id: "Id 1", body: "How are you?", fromUserId: "User 1", toUserId: "User 2", roomId: nil, createdTime: 200, readStatus: false, sequenceNumner: 0))
    }
}
