//
//  ChatRoomPreview.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 19/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct ChatRoomPreview: View {
    @State var lastMessage: FirebaseMessage
    var body: some View {
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

struct ChatRoomPreview_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomPreview(lastMessage: FirebaseMessage(id: "id 1", body: "TEst mesaage dsfhdsjfsdf dsfkdshfkds fnds,mfndsjkfn dsm,fds,mfndsfndsm,fndsm,f dsmfndsmfn dms,fndsm,fndsm, fndsm,fndsm,f ndsm,fndsm,f", fromUserId: "From user 1", toUserId: "To user 2", roomId: nil, createdTime: Int(Date().timeIntervalSince1970)))
    }
}
