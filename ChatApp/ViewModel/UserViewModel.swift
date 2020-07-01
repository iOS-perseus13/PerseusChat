//
//  UserViewModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//
import SwiftUI
import Firebase


protocol UserOperations{
    func register(name: String, profileImage: Data?, email: String, password: String, completion: @escaping(Bool)->Void)
    func logIn(email: String, password: String, completion: @escaping(Bool)->Void)
    func logOut(completion: @escaping(Bool)->Void)
    func sendMessage(message: [String: Any], completion: @escaping(Bool)->Void)
    func sendPasswordResetEmail(email: String, completion: @escaping (Bool) -> Void)
}



class UserViewModel: ObservableObject {
    @Published var logInState: LogInState = .notLoggenIn
    @Published var user: FirebaseUser?
    @Published var viewToShow: AuthenticationViewTypes = .login
    @Published var error: FireBaseError?
    @Published var profileImage: UIImage?
    @Published var chatRooms: [FirebaseChatRoom] = []
    @Published var users: [FirebaseUser] = []
    @Published var messages: [FirebaseMessage] = []
    @Published var lastMessages: [FirebaseMessage] = [] {
        didSet {
            print("found : \(lastMessages.count) items")
        }
    }
    
    
    @ObservedObject var firebaseManager = FirebaseManager()
    
    init(){
        
    }
    func checkForCachedUser(){
        firebaseManager.isProfileExists { (result) in
            switch result{
            case .success(let user):
                // check for UserDefaults, if data exists no need to save
                // otherwise save it to userDefaults
                print("profile found through cache")
                self.user = user
                self.loadUserProfileImage(userID: user.id)
                let queue1 = OperationQueue()
                queue1.addOperation {
                    self.loadUsers()
                }
                let queue2 = OperationQueue()
                queue2.addOperation {
                    self.loadMessages()
                }
            case .failure(let error):
                self.error = FireBaseError.other(message: error.localizedDescription)
                //self.logInState = .notLoggenIn
                //self.viewToShow = .login
                // clear userDefaults cache
                self.updateUserDefaults(operationType: .delete)
            }
        }
    }
    private func loadUserProfile(userID: String){
        let operation = BlockOperation {
            
        }
        let queue = OperationQueue()
        queue.addOperation(operation)
    }
    
    private func loadUserProfileImage(userID: String?){
        guard let userID = userID else {return}
        self.firebaseManager.loadProfileImage(userID: userID) { (result) in
            switch result{
            case .success(let image):
                DispatchQueue.main.async {
                    self.profileImage = image
                    self.updateUserDefaults(operationType: .create)
                }
            case .failure(let error):
                print("Error loading profile image: \(error.localizedDescription)")
            }
            self.logInState = .loggedIn
            self.viewToShow = .home
        }
    }
    private func updateUserDefaults(operationType: UserDefaultsOperationTypes){
        switch operationType{
        case .create:
            break
        case .delete:
            break
        case .search:
            break
        case .update:
            break
        }
        
    }
    func loadUsers(){
        let loadUsersOperation = BlockOperation{
            self.firebaseManager.loadUsers { (result) in
                switch result{
                case .success(let users):
                    print("total user found: \(users.count)")
                    self.users = users
                case .failure(let error):
                    print("Error after loading the user list: \(error.localizedDescription)")
                }
            }
        }
        let queue = OperationQueue()
        queue.addOperation(loadUsersOperation)
        //queue.waitUntilAllOperationsAreFinished()
        print("loading user operation queued.")
    }
    func loadMessages(){
        let loadMessagesOperation = BlockOperation{
            self.firebaseManager.loadMessages { (result) in
                switch result{
                case .success(let messages):
                    print("total messages found for current user: \(messages.count)")
                    self.lastMessages = messages.filter({
                        $0.toUserId == self.user?.id
                    })
                    self.messages = messages
                case .failure(let error):
                    print("Error after loading the messages: \(error.localizedDescription)")
                }
            }
        }
        let queue = OperationQueue()
        queue.addOperation(loadMessagesOperation)
        print("loading user related messages operation queued.")
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
        if let message = self.messages.last(where: { $0.fromUserId == senderID && $0.toUserId == self.user?.id }) {
            firebaseMessage = message
        }
        return firebaseMessage
    }
    func getMessages(roomID: String, roomType: FirebaseChatRoomType)->[FirebaseMessage]{
        var firebaseMessages: [FirebaseMessage] = [] // df
        switch roomType {
        case .individualChat:
            let messages = self.messages.filter({ $0.roomId == nil})
                .filter({
                    Set(arrayLiteral: $0.fromUserId, $0.toUserId) == Set(arrayLiteral: self.user?.id, roomID)})
            firebaseMessages = messages
        case .groupChat:
            let messages = self.messages.filter({$0.roomId == roomID})
            firebaseMessages = messages
        }
        return firebaseMessages
    }
    
}

extension UserViewModel: UserOperations{
    // register user
    func register(name: String, profileImage: Data?, email: String, password: String, completion: @escaping(Bool)->Void){
        firebaseManager.createUser(email: email, password: password) { (result) in
            switch result{
            case .success(let user):
                if let data = profileImage {
                    self.firebaseManager.updateProfileImage(userID: user.uid, imageData: data) { (result) in
                        switch result {
                        case .success(let imageURL):
                            self.firebaseManager.createProfile(name: name, user: user, locationURL: imageURL) { (result) in
                                switch result {
                                case .success(let firebaseUser):
                                    self.user = firebaseUser
                                    self.profileImage = UIImage(data: data)
                                    completion(true)
                                case .failure(let error):
                                    print("Error on saving picture: \(error.localizedDescription)")
                                    completion(false)
                                }
                            }
                        case .failure(let error):
                            print("Unable to load profile image: \(error.localizedDescription)")
                            completion(false)
                        }
                    }
                }
                else {
                    self.firebaseManager.createProfile(name: name, user: user, locationURL: "") { (result) in
                        switch result {
                        case .success(let firebaseUser):
                            self.user = firebaseUser
                            completion(true)
                        case .failure(let error):
                            print("Unable to save profile...:\(error.localizedDescription)")
                            completion(false)
                        }
                    }
                }
            case .failure(let error):
                self.error = FireBaseError.other(message: error.localizedDescription)
                completion(false)
            }
        }
    }
    
    // log in
    func logIn(email: String, password: String, completion: @escaping(Bool)->Void) {
        firebaseManager.loginUser(email: email, password: password) { (result) in
            switch result{
            case .success(_):
                self.checkForCachedUser()
            case .failure(let error):
                self.error = FireBaseError.other(message: error.localizedDescription)
                //self.viewToShow = .login
                //self.logInState = .error
                print("login error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    // log Out
    func logOut(completion: @escaping (Bool) -> Void) {
        firebaseManager.logOut { (result) in
            switch result{
            case .success(let status):
                completion(status)
            case .failure(let error):
                self.error = FireBaseError.other(message: error.localizedDescription)
                completion(false)
            }
        }
    }
    
    // send message
    func sendMessage(message: [String : Any], completion: @escaping (Bool) -> Void) {
        guard let userID = self.user?.id, !userID.isEmpty else {
            completion(false)
            return
        }
        var messageDictionary = message
        messageDictionary["fromUserId"] = self.user?.id
        messageDictionary["createdTime"] = Int(Date().timeIntervalSince1970)
        messageDictionary["readStatus"] = false
        messageDictionary["sequenceNumner"] = self.messages.count
        firebaseManager.sendMessage(userID: userID, message: messageDictionary) { (result) in
            switch result{
            case .success(let status):
                completion(status)
            case .failure(let error):
                print("Sending message failed: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    // reset password
    func sendPasswordResetEmail(email: String, completion: @escaping (Bool) -> Void){
        firebaseManager.sendPasswordResetEmail(email: email) { (result) in
            switch result{
            case .success(let staus):
                completion(staus)
            case .failure(let error):
                self.error = FireBaseError.other(message: error.localizedDescription)
                completion(false)
            }
        }
    }
}
