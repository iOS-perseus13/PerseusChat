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

class FirebaseAuthManager: ObservableObject{
    var email: String = ""
    @Published var loginState: Bool = false
    @Published var currentUser: FIRUser?
    init(){
        if let user = Auth.auth().currentUser {
            self.currentUser = user
            self.loginState = true
        }
    }
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
