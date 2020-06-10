//
//  FirebaseImageLoader.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 09/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseStorage

class FirebaseImageLoader: ObservableObject {
    @Published var data: Data?
    
    init(userID: String?){
        guard let userID = userID else { return }
        print("Loading .... image ")
        let storage = Storage.storage()
        let storageReferance = storage.reference(forURL: "gs://perseus-chat-app.appspot.com/")
        let storageProfileReference = storageReferance.child("profile").child(userID)
        storageProfileReference.getData(maxSize: 1*1024*1024) { (data, error) in
            if let data = data {
                self.data = data
            }
        }
    }
}


