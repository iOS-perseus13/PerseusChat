//
//  FirebaseManager.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

typealias FIRUser = FirebaseAuth.User

import FirebaseAuth
import Firebase
import FirebaseFirestore
import CoreLocation



enum FireBaseError: Error{
    case invalidCache
    case jsonDecodingError
    case userAlreadyExists
    case userDoesNotExist
    case other(message: String)
    var localizedDescription: String{
        switch self{
        case .userDoesNotExist: return "no such user"
        case .userAlreadyExists: return "user already exists"
        default: return "something went wrong \(self)"
        }
    }
}

protocol FireBaseManagerType: class {
    //    func isUserExists(email: String, completion: @escaping (Result<Bool?, FireBaseError>)->Void)
    //    func sendPasswordReset(email: String, completion: @escaping (Result<Bool?, FireBaseError>)->Void)
    //    func createUser(loginInfo: LoginInfo, completion: @escaping (Result<UserProfile?, FireBaseError>)->Void)
    //    func loginUser(loginInfo: LoginInfo, completion: @escaping (Result<UserProfile?, FireBaseError>)->Void)
    //    func loadUserProfile(userID: String, completion: @escaping (Result<UserProfile?, FireBaseError>)->Void)
    //    func saveUserProfile(userID: String, userProfile: UserProfile, completion: @escaping(Result<Bool?,FireBaseError>)->Void)
    //    func saveProfileImage(userID: String, profileImage: UIImage?, completion: @escaping (Result<String?, FireBaseError>)->Void)
    //    func loadProfileImage(userID: String, completion: @escaping (Result<UIImage?, FireBaseError>)->Void)
    //    func updateLocation(forUser userID: String, location:CLLocation, completion: @escaping (Result<Bool?, FireBaseError>)->Void)
    //
    // Message
    //    func sendMessage(){
    //
    //    }
    //
    //    // Chatroom
    //    func createChatRoom(){
    //
    //    }
}






//extension FirebaseAuthManager: FireBaseManagerType{
//    static let shared = FirebaseAuthManager()
//    private init(){}
//    var currentUserProfile: UserProfile = UserProfile()
//    var loginState: Bool = false
//    var currentUser:FIRUser? {
//        return Auth.auth().currentUser
//    }
//
//    func isUserExists(email: String, completion: @escaping (Result<Bool?, FireBaseError>) -> Void) {
//        Auth.auth().fetchSignInMethods(forEmail: email) { (signInMethods, error ) in
//            if let error = error{
//                completion(.failure(.other(message: error.localizedDescription)))
//            } else if let signInMethods = signInMethods{
//                if signInMethods.contains("password") {
//                    completion(.success(true))
//                } else {
//                    completion(.success(false))
//                }
//            }
//        }
//    }
//
//
//    func sendPasswordReset(email: String, completion: @escaping (Result<Bool?, FireBaseError>) -> Void) {
//        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
//            if let error = error {
//                completion(.failure(.other(message: error.localizedDescription)))
//            } else {
//                completion(.success(true))
//            }
//        }
//    }
//
//    func createUser(loginInfo: LoginInfo, completion: @escaping (Result<UserProfile?, FireBaseError>)->Void){
//        Auth.auth().createUser(withEmail: loginInfo.email, password: loginInfo.password) { (authResult, error) in
//            if let error = error {
//                completion(.failure(.other(message: error.localizedDescription)))
//            } else if let data = authResult {
//                self.loadUserProfile(userID: data.user.uid) { (result) in
//                    switch result{
//                    case .success(let userProfile):
//                        if let userProfile = userProfile {
//                           // self.currentUserProfile = userProfile
//                        }
//                    case .failure(_):
//                        break
//                    }
//                }
//                completion(.success(self.currentUserProfile))
//                self.loginState = true
//            }
//        }
//    }
//    func loginUser(loginInfo: LoginInfo, completion: @escaping (Result<UserProfile?, FireBaseError>)->Void){
//        Auth.auth().signIn(withEmail: loginInfo.email, password: loginInfo.password) { (authResult, error) in
//            if let data = authResult {
//                self.loadUserProfile(userID: data.user.uid) { (result) in
//                    switch result{
//                    case .success(let userProfile):
//                        if let userProfile = userProfile {
//                            self.currentUserProfile = userProfile
//                            completion(.success(self.currentUserProfile))
//                        }
//                    case .failure(_):
//                        break
//                    }
//                }
//            } else if let error = error {
//                completion(.failure(.other(message: error.localizedDescription)))
//            }
//        }
//    }
//    func loadProfileImage(userID: String, completion: @escaping (Result<UIImage?, FireBaseError>)->Void){
//        let storage = Storage.storage()
//        let storageReferance = storage.reference(forURL: "gs://perseus-chat-app.appspot.com/")
//        let storageProfileReference = storageReferance.child("profile").child(userID)
//        storageProfileReference.getData(maxSize: 3*1024*1024) { (data, error) in
//            if let data = data, let image = UIImage(data: data) {
//                completion(.success(image))
//            } else if let error = error {
//                completion(.failure(.other(message: error.localizedDescription)))
//            }
//        }
//    }
//    func loadUserProfile(userID: String, completion: @escaping (Result<UserProfile?, FireBaseError>)->Void) {
//        switch userID.isEmpty {
//        case true:
//            completion(.failure(.other(message: "Invalid user ID")))
//        case false:
//            let db = Firestore.firestore()
//            db.collection("users").document(userID).getDocument { (snapShot, error) in
//                if let error = error {
//                    completion(.failure(.other(message: error.localizedDescription)))
//                } else if let snapShot = snapShot{
//                    var userProfile = UserProfile()
//                    userProfile.userID = userID
//                    userProfile.firstName = snapShot["firstName"] as? String
//                    userProfile.lastName = snapShot["lastName"] as? String
//                    self.loadProfileImage(userID: userID) { (result) in
//                        switch result{
//                        case .failure(_):
//                            completion(.success(userProfile))
//                        case .success(let image):
//                            userProfile.profileImage = image
//                            completion(.success(userProfile))
//                        }
//                    }
//                }
//            }
//        }
//    }
//    func saveUserProfile(userID: String, userProfile: UserProfile, completion: @escaping(Result<Bool?,FireBaseError>)->Void){
//        var profileImageURL = ""
//        switch userID.isEmpty{
//        case true:
//            completion(.failure(.other(message: "Invalid user ID")))
//        case false:
//            saveProfileImage(userID: userID, profileImage: userProfile.profileImage) { (result) in
//                switch result {
//                case .success(let imageURL):
//                    if let url = imageURL {
//                        profileImageURL = url
//                    }
//                    let profileDictionary: [String: Any] =
//                        [ "firstName" : userProfile.firstName ?? "",
//                          "lastName" : userProfile.lastName ?? "",
//                          "profileImageURL": profileImageURL
//                    ]
//                    let db = Firestore.firestore()
//                    db.collection("users").document(userID).setData(profileDictionary) { (error) in
//                        if let error = error {
//                            completion(.failure(.other(message: error.localizedDescription)))
//                        } else {
//                            self.currentUserProfile = userProfile
//                            completion(.success(true))
//                        }
//                    }
//                case .failure(let error):
//                    completion(.failure(.other(message: error.localizedDescription)))
//                }
//            }
//        }
//    }
//
//    func saveProfileImage(userID: String, profileImage: UIImage?, completion: @escaping (Result<String?, FireBaseError>)->Void){
//        guard let imageData = profileImage?.jpegData(compressionQuality: 0.35) else {
//            completion(.failure(.other(message: "Error on saving profile image")))
//            return }
//        let storage = Storage.storage()
//        let storageReferance = storage.reference()
//        let storageProfileReference = storageReferance.child("profile").child(userID)
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpg"
//        storageProfileReference.putData(imageData, metadata: metaData) { (storageMetaData, error) in
//            if let error = error {
//                completion(.failure(.other(message: error.localizedDescription)))
//            } else {
//                storageProfileReference.downloadURL { (url, error) in
//                    if let error = error {
//                        completion(.failure(.other(message: error.localizedDescription)))
//                    } else if let url = url {
//                        completion(.success(url.absoluteString))
//                    }
//                }
//            }
//        }
//    }
//    func clearUserDefaults(){
//        if let domain = Bundle.main.bundleIdentifier{
//            UserDefaults.standard.removePersistentDomain(forName: domain)
//            UserDefaults.standard.synchronize()
//        }
//    }
//
//    func updateLocation(forUser userID: String, location:CLLocation, completion: @escaping (Result<Bool?, FireBaseError>)->Void){
//        let db = Firestore.firestore()
//        let locationDictionary: [String: Any] =
//            [ "latitude" : String(location.coordinate.latitude),
//              "longitude" : String(location.coordinate.longitude),
//              "date" : location.timestamp.description
//        ]
//        db.collection("locations").document(userID).collection("locations").addDocument(data: locationDictionary){ (error) in
//            if let error = error {
//                completion(.failure(.other(message: error.localizedDescription)))
//            } else {
//                completion(.success(true))
//            }
//        }
//    }
//}
//


enum FirebaseLocations: String{
    case userProfiles
    case profileImages
    case messages
    var location: String {
        switch self{
        case .profileImages: return "gs://perseus-chat-app.appspot.com/"
        default: return ""
        }
    }
}

class FirebaseManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var user: Firebase.User?
    private var userListner: ListenerRegistration? = nil
    private var messageListner: ListenerRegistration? = nil
    
    init(){
    }
    // if profile exists load the profile
    func isProfileExists(completion: @escaping(Result<FirebaseUser,Error>)->Void){
        if let user = Auth.auth().currentUser{
            let fireStore = Firestore.firestore()
            let docRef = fireStore.collection(FirebaseLocations.userProfiles.rawValue)
            docRef.whereField("id", isEqualTo: user.uid).getDocuments { (docSnapshot, error) in
                if let error = error {
                    print("Error decoding firebase userProfiles: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                else if let dict = docSnapshot?.documents.first?.data(){
                    if let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                        do {
                            let genericModel = try JSONDecoder().decode(FirebaseUser.self, from: data)
                            print("user profile decoding complete")
                            completion(.success(genericModel))
                        }
                        catch (let error) {
                            print("Error .......: \(error.localizedDescription)")
                            completion(.failure(FireBaseError.jsonDecodingError))
                        }
                    }
                    else {
                        print("user profile decoding Error.....")
                        completion(.failure(FireBaseError.jsonDecodingError))
                    }
                }
                else {
                    print("Invalid cache ....")
                    completion(.failure(FireBaseError.invalidCache))
                }
            }
        }
        else {
            self.isLoggedIn = false
            self.user = nil
            completion(.failure(FireBaseError.userDoesNotExist))
        }
    }
    
    
    // fetch user profile image
    func loadProfileImage(userID: String, completion: @escaping(Result<UIImage,Error>)->Void){
        let storage = Storage.storage()
        let storageReferance = storage.reference(forURL: FirebaseLocations.profileImages.location)
        let storageProfileReference = storageReferance.child(FirebaseLocations.profileImages.rawValue).child(userID)
        storageProfileReference.getData(maxSize: 3*1024*1024) { (data, error) in
            if let data = data, let image = UIImage(data: data) {
                print("Profile image loaded....")
                completion(.success(image))
            } else if let error = error {
                print("Error loading image from firebase: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    
    // create user
    func createUser(email: String, password: String, completion:@escaping(Result<Firebase.User,Error>)->Void){
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            // create user failed
            if let error = error{
                completion(.failure(error))
            } else if let user = authDataResult?.user{
                // if image presents
                completion(.success(user))
            }
        }
    }
    
    // save Profile Image
    func updateProfileImage(userID: String, imageData: Data, completion: @escaping(Result<String,Error>)->Void){
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        let storageProfileReference = storageReferance.child(FirebaseLocations.profileImages.rawValue).child(userID)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageProfileReference.putData(imageData, metadata: metaData) { (storageMetaData, error) in
            if let error = error {
                print("Profile image could not be saved....")
                completion(.failure(error))
            } else {
                storageProfileReference.downloadURL { (url, error) in
                    if let error = error {
                        print("Profile image could not be saved....")
                        completion(.failure(error))
                    } else if let url = url?.absoluteString {
                        completion(.success(url))
                    }
                }
            }
        }
    }
    
    // Create profile
    func createProfile(name: String, user: Firebase.User, locationURL: String){
        guard let email = user.email else {return}
        let database = Firestore.firestore()
        var userProfile: [String: Any] = [:]
        userProfile = [ "id": user.uid,
                        "email": email,
                        "name" : name
        ]
        if !locationURL.isEmpty {
            userProfile["profileURL"] = locationURL
        }
        database.collection(FirebaseLocations.userProfiles.rawValue).addDocument(data: userProfile) { (error) in
            print("User profile for register: \(userProfile)")
            if let _ = error {
                print("Profile image could not be saved....")
            } else {
                print("Profile image saved....")
            }
        }
    }
    
    
    // sign In
    func loginUser(email: String, password: String, completion: @escaping (Result<Firebase.User, Error>)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    // log Out
    func logOut(completion: @escaping(Result<Bool,Error>)->Void){
        guard let _ = Auth.auth().currentUser?.uid else {return}
        do {
            try Auth.auth().signOut()
            completion(.success(true))
        }
        catch (let error){
            print("Logout failed: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    // load users
    func loadUsers(completion: @escaping(Result<[FirebaseUser],Error>)->Void){
        let database = Firestore.firestore()
        self.userListner = database.collection(FirebaseLocations.userProfiles.rawValue).addSnapshotListener { (snapShot, error) in
            if let error = error {
                print("Error loading users: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let snapShot = snapShot {
                var users : [FirebaseUser] = []
                for document in snapShot.documents {
                    let dict = document.data()
                    if let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                        do {
                            let genericModel = try JSONDecoder().decode(FirebaseUser.self, from: data)
                            users.append(genericModel)
                        }
                        catch (let error) {
                            completion(.failure(error))
                            print("Error loading users.......: \(error.localizedDescription)")
                        }
                    }
                }
                users = users.sorted(by: { (lhs, rhs)  in
                    lhs.name < rhs.name
                })
                completion(.success(users))
            }
        }
    }
    
    // load Messages
    func loadMessages(completion: @escaping(Result<[FirebaseMessage],Error>)->Void){
        let database = Firestore.firestore()
        self.messageListner = database.collection(FirebaseLocations.messages.rawValue).addSnapshotListener { (snapShot, error) in
            if let error = error {
                print("Error loading messages: \(error.localizedDescription)")
                completion(.failure(error))
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
                            completion(.failure(error))
                        }
                    }
                }
                messages.sort {
                    $0.sequenceNumner < $1.sequenceNumner
                }
                completion(.success(messages))
            }
        }
    }
    
    // send message
    func sendMessage(userID: String, message: [String: Any], completion: @escaping(Result<Bool, Error>)->Void){
        let database = Firestore.firestore()
        database.collection(FirebaseLocations.messages.rawValue).addDocument(data: message) { (error) in
            if let error = error{
                print("failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
            else {
                print("success")
                completion(.success(true))
            }
        }
    }
}

/*
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
 */

