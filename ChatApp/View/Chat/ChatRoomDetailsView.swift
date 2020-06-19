//
//  ChatRoomDetailsVoew.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 19/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct ChatRoomDetailsView: View {
    @State var roomName: String
    var body: some View {
        VStack {
            //List of Messages
            Text("Welcome to room: .....")
        }.navigationBarTitle(Text(roomName), displayMode: .inline)
        
    }
}

struct ChatRoomDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomDetailsView(roomName: "Test")
    }
}
