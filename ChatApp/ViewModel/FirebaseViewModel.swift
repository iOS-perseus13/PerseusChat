//
//  FirebaseViewModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 05/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI
import Firebase

protocol FirebaseOperations{
    func fetchUserProfile(withUserId userID: String, completion: @escaping (FirebaseUser?)->Void )
    func registerUser(name: String, profileImage: UIImage?, email: String, password: String, completion: @escaping (Bool) -> Void)
    func logoutUser(completion: @escaping (Bool) -> Void)
    func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void)
    func sendPasswordResetEmail(email: String, completion: @escaping (Result<Bool, Error>) -> Void)
    // func createChatRoom(chatRoomName: String, completion: @escaping (Result<Bool, Error>)->Void)
    func loadUsers()
    func loadUserProfile(completion: @escaping(Bool)->Void)
    func sendMessage(message: [String: Any], completion: @escaping(Bool)->Void)
}

class FirebaseViewModel: ObservableObject {
    @Published var isLogedIn: Bool = false
    @Published var viewToShow: AuthenticationViewTypes = .unknown
    @Published var profileImage: UIImage?
    @Published var chatRooms: [FirebaseChatRoom] = []
    @Published var users: [FirebaseUser] = []
    @Published var messages: [FirebaseMessage] = []
    @Published var error: Error?
    @Published var currentUser: FirebaseUser?
    private var listner: ListenerRegistration? = nil
    init(){
    }
    
    func fetchUserProfile(withUserId userID: String, completion: @escaping (FirebaseUser?)->Void ){
        let fireStore = Firestore.firestore()
        let docRef = fireStore.collection("userProfiles")
        docRef.whereField("id", isEqualTo: userID)
            .getDocuments { (docSnapshot, error) in
                if let error = error {
                    print("Error decoding firebase userProfiles: \(error.localizedDescription)")
                    return
                }
                else if let dict = docSnapshot?.documents.first?.data(){
                    if let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                        do {
                            let genericModel = try JSONDecoder().decode(FirebaseUser.self, from: data)
                            print("user profile decoding complete")
                            completion(genericModel)
                        }
                        catch (let error) {
                            print("Error .......: \(error.localizedDescription)")
                            completion(nil)
                        }
                    }
                    else {
                        print("user profile decoding Error.....")
                        completion(nil)
                    }
                }
                else {
                    print("Invalid cache ....")
                    completion(nil)
                }
        }
    }
    
    func loadUserProfile(completion: @escaping(Bool)->Void) {
        if let userID = Auth.auth().currentUser?.uid {
            self.fetchUserProfile(withUserId: userID) { (user) in
                if let user = user{
                    print("Current user profile found")
                    self.currentUser = user
                    print("Current user login State: \(user.loginState)")
                    self.isLogedIn = user.loginState
                    DispatchQueue.main.async {
                        //   self.loadProfileImage()
                        self.loadUsers()
                    }
                    completion(true)
                } else {
                    print("no current user profile found to load")
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
        
    }
    func clearData(){
        self.isLogedIn = false
        self.viewToShow = .login
        self.currentUser = nil
        self.profileImage = nil
    }
    func loadProfileImage(){
        if let userID = Auth.auth().currentUser?.uid {
            let storage = Storage.storage()
            let storageReferance = storage.reference(forURL: "gs://perseus-chat-app.appspot.com/")
            let storageProfileReference = storageReferance.child("profile").child(userID)
            storageProfileReference.getData(maxSize: 3*1024*1024) { (data, error) in
                if let data = data, let image = UIImage(data: data) {
                    print("Profile image loaded....")
                    self.profileImage = image
                } else if let error = error {
                    print("Error loading image from firebase: \(error.localizedDescription)")
                }
            }
        }
    }
    func saveProfileImage(userID: String, profileImage: UIImage?){
        let database = Firestore.firestore()
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        let storageProfileReference = storageReferance.child("profile").child(userID)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        // profile image given
        if let imageData = profileImage?.jpegData(compressionQuality: 0.35) {
            storageProfileReference.putData(imageData, metadata: metaData) { (storageMetaData, error) in
                if let _ = error {
                    print("Profile image could not be saved....")
                } else {
                    storageProfileReference.downloadURL { (url, error) in
                        if let _ = error {
                            print("Profile image could not be saved....")
                        } else if let url = url {
                            var userProfile: [String: Any] = [:]
                            userProfile = [ "id": userID,
                                            "email": self.currentUser?.email ?? "",
                                            "name" : self.currentUser?.name ?? "",
                                            "profileURL": url.absoluteString,
                                            "loginState": self.currentUser?.loginState ?? false
                            ]
                            database.collection("userProfiles").addDocument(data: userProfile) { (error) in
                                print("User profile for register: \(userProfile)")
                                if let _ = error {
                                    print("Profile image could not be saved....")
                                } else {
                                    print("Profile image saved....")
                                    self.currentUser?.profileImageURL = url.absoluteString
                                    self.profileImage = profileImage
                                }
                            }
                        }
                    }
                }
            }
        }
            // no image selected
        else {
            var userProfile: [String: Any] = [:]
            userProfile = [ "id": userID,
                            "email": self.currentUser?.email ?? "",
                            "name" : self.currentUser?.name ?? "",
                            "profileURL": "",
                            "loginState": self.currentUser?.loginState ?? false
            ]
            database.collection("userProfiles").addDocument(data: userProfile) { (error) in
                print("User profile for register: \(userProfile)")
                if let _ = error {
                    print("Profile image could not be saved....")
                } else {
                    print("Profile image not selected ....")
                    self.currentUser?.profileImageURL = ""
                    self.profileImage = nil
                }
            }
        }
    }
    private func loadChatRooms(){
        if let userID = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            let docRef = db.collection("chatRooms")
            docRef.whereField("admin", isEqualTo: "\(userID)")
                //.order(by: "created")
                .getDocuments { (snapShot, error) in
                    if let error = error {
                        print("chat room loading error: \(error.localizedDescription)")
                    } else if let snapShot = snapShot {
                        print("documnet found: \(snapShot.count)")
                        print("Document: \(snapShot.documents.first?.data())")
                    }
            }
        }
    }
    // get user from UserID
    func getUser(userID: String)->FirebaseUser? {
        var firebaseUser: FirebaseUser?
        if let user = self.users.first(where: { $0.id == userID }) {
            firebaseUser = user
        }
        return firebaseUser
    }
    // get ChatRoom from roomID
    func getChatRoom(roomID: String?)->FirebaseChatRoom? {
        var firebaseChatRoom: FirebaseChatRoom?
        if let chatRoom = self.chatRooms.first(where: { $0.id == roomID }) {
            firebaseChatRoom = chatRoom
        }
        return firebaseChatRoom
    }
    // get Message from MessageID
    func getMessage(messageID: String)->FirebaseMessage? {
        var firebaseMessage: FirebaseMessage?
        if let message = self.messages.first(where: { $0.id == messageID }) {
            firebaseMessage = message
        }
        return firebaseMessage
    }
    func getLastMessage(senderID: String)->FirebaseMessage? {
        var firebaseMessage: FirebaseMessage?
        if let message = self.messages.first(where: { $0.fromUserId == senderID && $0.toUserId == self.currentUser?.id }) {
            firebaseMessage = message
        }
        return firebaseMessage
    }
    func getMessages(roomID: String, roomType: FirebaseChatRoomType)->[FirebaseMessage]{
        var firebaseMessages: [FirebaseMessage] = []
        switch roomType {
        case .individualChat:
            let messages = self.messages.filter({ $0.roomId == nil})
                .filter({
                    Set(arrayLiteral: $0.fromUserId, $0.toUserId) == Set(arrayLiteral: self.currentUser?.id, roomID)})
            firebaseMessages = messages
        case .groupChat:
            let messages = self.messages.filter({$0.roomId == roomID})
            firebaseMessages = messages
        }
        return firebaseMessages
    }
}

extension FirebaseViewModel: FirebaseOperations {
    
    func registerUser(name: String, profileImage: UIImage?, email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            // create user failed
            if let error = error{
                self.error = error
                completion(false)
            } else if let data = authDataResult {
                let userID = data.user.uid
                self.currentUser = FirebaseUser(id: userID, email: email, name: name, profileImageURL: "", loginState: true)
                DispatchQueue.main.async {
                    self.saveProfileImage(userID: userID, profileImage: profileImage)
                }
                self.isLogedIn = true 
                completion(true)
            }
        }
    }
    
    
    func logoutUser(completion: @escaping (Bool) -> Void){
        do {
            try Auth.auth().signOut()
            if let userID = self.currentUser?.id,
                let name = self.currentUser?.name,
                let email = self.currentUser?.email
            {
                print("User ID: \(userID)")
                print("User Name: \(name)")
                print("User Email: \(email)")
                
                var userProfile: [String: Any] = [:]
                userProfile = [ "id": userID,
                                "email": email,
                                "name" : name,
                                "profileURL": "",
                                "loginState": false
                ]
                let fireStore = Firestore.firestore()
                let docRef = fireStore.collection("userProfiles").document(userID)
                
                docRef.setData(userProfile) { (error) in
                    print("User Profile: \(userProfile)")
                    if let error = error {
                        print("Failed to log out: \(error.localizedDescription)")
                    }
                    else {
                        print("success")
                    }
                }
            }
        }
        catch (let err){
            print("Logout failed: \(err.localizedDescription)")
            self.error = err
            self.isLogedIn = false
            self.viewToShow = .login
            completion(false)
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error{
                self.error = error
                completion(false)
            } else if let userID = authDataResult?.user.uid {
                self.fetchUserProfile(withUserId: userID) { (user) in
                    if let _ = user {
                        self.isLogedIn = true
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
                
            }
        }
    }
    func sendPasswordResetEmail(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                completion(.failure(error))
            }
            else {
                completion(.success(true))
            }
        }
    }
    func sendMessage(message: [String: Any], completion: @escaping(Bool)->Void){
        guard let userID = self.currentUser?.id, !userID.isEmpty else {
            self.error = FireBaseError.other(message: "Failed to load current user")
            completion(false)
            return
        }
        let database = Firestore.firestore()
        var messageDictionary = message
        messageDictionary["fromUserId"] = userID
        messageDictionary["createdTime"] = Int(Date().timeIntervalSince1970)
        messageDictionary["readStatus"] = false
        messageDictionary["sequenceNumner"] = self.messages.count
        database.collection("messages").addDocument(data: messageDictionary) { (error) in
            if let error = error{
                self.error = error
                completion(false)
            }
            completion(true)
        }
    }
    
    
    func loadUsers() {
        //self.users.removeAll()
        let database = Firestore.firestore()
        self.listner = database.collection("userProfiles").addSnapshotListener { (snapShot, error) in
            if let error = error {
                print("Error loading users: \(error.localizedDescription)")
            } else if let snapShot = snapShot {
                var users : [FirebaseUser] = []
                for document in snapShot.documents {
                    let dict = document.data()
                    if let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                        do {
                            let genericModel = try JSONDecoder().decode(FirebaseUser.self, from: data)
                            if let userID = self.currentUser?.id, genericModel.id != userID {
                                users.append(genericModel)
                            }
                        }
                        catch (let error) {
                            print("Error .......: \(error.localizedDescription)")
                        }
                    }
                }
                self.users = users.sorted(by: { (lhs, rhs)  in
                    lhs.name < rhs.name
                })
                if self.users.isEmpty {
                    self.isLogedIn = false
                    self.viewToShow = .register
                }
                else {
                    self.isLogedIn = true
                }
                print("Now user count: \(self.users.count)")
            }
        }
    }
    
    
    func loadMessages() {
       // self.messages.removeAll()
        let database = Firestore.firestore()
        self.listner = database.collection("messages").addSnapshotListener { (snapShot, error) in
            if let error = error {
                print("Error loading messages: \(error.localizedDescription)")
            } else if let snapShot = snapShot {
                var messages : [FirebaseMessage] = []
                for document in snapShot.documents {
                    let dict = document.data()
                    if let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                        do {
                            var genericModel = try JSONDecoder().decode(FirebaseMessage.self, from: data)
                            genericModel.id = document.documentID
                            messages.append(genericModel)
                        }
                        catch (let error) {
                            print("Error .......: \(error.localizedDescription)")
                        }
                    }
                }
                messages.sort {
                    $0.sequenceNumner < $1.sequenceNumner
                }
                self.messages = messages
                print("Now Messages count: \(self.messages.count)")
            }
        }
    }
    
}
