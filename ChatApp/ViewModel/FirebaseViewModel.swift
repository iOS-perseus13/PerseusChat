//
//  FirebaseViewModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 22/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI
import Firebase

class FirebaseViewModel: ObservableObject {
    @Published var fUser: Firebase.User?
    @Published var user: FirebaseUser?
    @Published var profileImage: UIImage?
    @Published var users: [FirebaseUser] = []
    @Published var chatMessages: [FirebaseMessage] = []
    @Published var chatRooms: [FirebaseChatRoom] = []
    @Published var message: String?
    @Published var isError: Bool = false
    @Published var isCalculating: Bool = false
    private var userListner: ListenerRegistration? = nil
    private var messageListner: ListenerRegistration? = nil
    
    init(){
    }
    func clearData(){
        self.fUser = nil
        self.user = nil
        self.profileImage = nil
        self.users = []
        self.chatMessages = []
        self.chatRooms = []
        self.isError = false
        self.isCalculating = true
        self.stopListners()
        self.message = nil
    }
    func getUserProfileForAuthData(user: Firebase.User, completion: @escaping(Result<FirebaseUser,Error>)->Void){
        let queue = OperationQueue()
        let fetchUser = BlockOperation{
            let fireStore = Firestore.firestore()
            let userProfileReference = fireStore.collection(FirebaseLocations.userProfiles.rawValue)
            userProfileReference.whereField("id", isEqualTo: user.uid).getDocuments { (docSnapshot, error) in
                if let error = error{
                    // user profile not found
                    completion(.failure(error))
                }
                else if let dict = docSnapshot?.documents.first?.data(){
                    if let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                        do {
                            let genericModel = try JSONDecoder().decode(FirebaseUser.self, from: data)
                            completion(.success(genericModel))
                        }
                        catch (let error) {
                            completion(.failure(error))
                        }
                    }
                    else {
                        completion(.failure(FireBaseError.userDoesNotExist))
                    }
                }
                else {
                    completion(.failure(FireBaseError.userDoesNotExist))
                }
            }
        }
        queue.addOperation(fetchUser)
    }
    func isFirebaseLoggedInUserExists(completion: @escaping(Bool)->Void){
        if let user = Auth.auth().currentUser {
            self.getUserProfileForAuthData(user: user) { (result) in
                switch result{
                case .success(let firebaseUser):
                    self.user = firebaseUser
                    completion(true)
                case .failure(_):
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
    }
    func isLocallySavedUserExists()->Bool{
        if let user = UserDefaults.standard.getCurrentUser() {
            self.user = user
            return true
        }
        else {
            return false
        }
    }
    func loadUserProfile(completion: @escaping(Result<Bool,Error>)->Void){
        self.isFirebaseLoggedInUserExists { (status) in
            switch status{
            case true:
                if let user = self.user {
                    UserDefaults.standard.saveUser(user: user)
                    if user.profileImage != nil {
                        self.loadProfileImage { (status) in
                            if status {
                                completion(.success(true))
                            }
                        }
                    } else {
                        completion(.success(true))
                    }
                }
            case false:
                switch self.isLocallySavedUserExists() {
                case true:
                    if let profileImage = UserDefaults.standard.getProfileImage() {
                        self.profileImage = profileImage
                    }
                    completion(.success(true))
                case false:
                    self.clearData()
                    completion(.failure(FireBaseError.userDoesNotExist))
                }
            }
        }
    }
    func loadProfileImage(completion: @escaping(Bool)->Void){
        if let userID = self.user?.id {
            let queue = OperationQueue()
            queue.addOperation {
                let storage = Storage.storage()
                let storageReferance = storage.reference(forURL: FirebaseLocations.profileImages.location)
                let storageProfileReference = storageReferance.child(FirebaseLocations.profileImages.rawValue).child(userID)
                storageProfileReference.getData(maxSize: 3*1024*1024) { (data, error) in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.profileImage = image
                            UserDefaults.standard.saveProfileImage(image: image)
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    func logOut(completion: @escaping (Result<Bool,Error>) -> Void) {
        guard let _ = Auth.auth().currentUser?.uid else {
            print("check current user....")
            return}
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.clearUserData()
            self.stopListners()
            print("logout")
            completion(.success(true))
        }
        catch (let error){
            completion(.failure(error))
        }
    }
    func stopListners(){
        self.userListner?.remove()
        self.messageListner?.remove()
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
    func loginUser(email: String, password: String, completion: @escaping (Result<Bool, Error>)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let _ = authResult?.user {
                self.loadUserProfile() { (result) in
                    switch result{
                    case .success(let status):
                        completion(.success(status))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    func register(name: String, profileImage: Data?, email: String, password: String, completion: @escaping(Bool)->Void){
        var photoURL: String?
        let queue = OperationQueue()
        
        let createProfile = BlockOperation{
            if let fUser = self.fUser{
                let database = Firestore.firestore()
                var userProfile: [String: Any] = [:]
                userProfile = [ "id": fUser.uid,
                                "email": email,
                                "name" : name
                                ]
                if let imageURL = photoURL {
                    userProfile["profileURL"] = imageURL
                }
                database.collection(FirebaseLocations.userProfiles.rawValue).addDocument(data: userProfile) { (error) in
                    if let error = error {
                        self.message = error.localizedDescription
                        self.isError = true
                        self.user = nil
                        print("creating user profile with error: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        var firebaseUser = FirebaseUser()
                        firebaseUser.id = fUser.uid
                        firebaseUser.name = name
                        firebaseUser.email = email
                        if photoURL != nil {
                            firebaseUser.profileImage = photoURL!
                        }
                        DispatchQueue.main.async {
                            self.user = firebaseUser
                            completion(true)
                        }
                        print("creating user profile with success: \(firebaseUser)")
                        
                    }
                }
            }
        }

        
        
        
        
        
        let createProfileImage = BlockOperation{
            
            if let fUser = self.fUser, let imageData = profileImage {
                let storage = Storage.storage()
                let storageReferance = storage.reference()
                let storageProfileReference = storageReferance.child(FirebaseLocations.profileImages.rawValue).child(fUser.uid)
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"
                storageProfileReference.putData(imageData, metadata: metaData) { (storageMetaData, error) in
                    if let error = error {
                        self.message = error.localizedDescription
                        self.isError = true
                        DispatchQueue.main.async {
                            self.profileImage = nil
                        }
                        print("creating user profile picture with error: \(error.localizedDescription)")
                    } else {
                        storageProfileReference.downloadURL { (url, error) in
                            if let error = error {
                                self.message = error.localizedDescription
                                self.isError = true
                                DispatchQueue.main.async {
                                    self.profileImage = nil
                                }
                                print("creating user profile picture with error: \(error.localizedDescription)")
                            } else if let url = url?.absoluteString {
                                self.message = nil
                                self.isError = false
                                DispatchQueue.main.async {
                                    self.profileImage = UIImage(data: imageData)
                                }
                                photoURL = url
                                print("creating user profile picture with success: \(url)")
                                queue.addOperation(createProfile)
                            }
                        }
                    }
                }
            }
        }
        
        let createUser = BlockOperation {
            Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
                if let error = error {
                    self.fUser = nil
                    self.message = error.localizedDescription
                    self.isError = true
                    print("finished createUser with error: \(error.localizedDescription)")
                }
                if let user = authDataResult?.user {
                    self.fUser = user
                    self.message = nil
                    self.isError = false
                    print("finished createUser with success: \(self.fUser?.uid)")
                    queue.addOperation(createProfileImage)
                }
            }
        }

        //createProfileImage.addDependency(createUser)
        //createProfile.addDependency(createProfileImage)
        //checkStatus.addDependency(createProfile)
        
        queue.addOperation(createUser)
        
        
        
      //  queue.waitUntilAllOperationsAreFinished()
    }
    
    
    
    
    
    // create user
//    func createUser(name: String, profileImage: Data?, email: String, password: String, completion:@escaping(Result<FirebaseUser,Error>)->Void){
//        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
//            // create user failed
//            if let error = error{
//                completion(.failure(error))
//            } else if let user = authDataResult?.user{
//                // if image presents
//                if let data = profileImage {
//                    let saveProfileImage = BlockOperation {
//                        self.updateProfileImage(userID: user.uid, imageData: data) { (result) in
//                            switch result{
//                            case .success(let imageURL):
//                                self.profileImage = UIImage(data: data)
//                                let saveUserProfile = BlockOperation {
//                                    self.createProfile(name: name, user: user, locationURL: imageURL) { (result) in
//                                        switch result{
//                                        case .success(let firebaseUser):
//                                            completion(.success(firebaseUser))
//                                        case .failure(let error):
//                                            completion(.failure(error))
//                                        }
//                                    }
//                                }
//                                let queue = OperationQueue()
//                                queue.addOperation(saveUserProfile)
//                            case .failure(let error):
//                                print("couldnot save image...: \(error.localizedDescription)")
//                            }
//                        }
//                    }
//                    let queue = OperationQueue()
//                    queue.addOperation(saveProfileImage)
//                }
//            }
//        }
//    }
//    func createProfile(name: String, user: Firebase.User, locationURL: String, completion: @escaping(Result<FirebaseUser,Error>)->Void){
//        guard let email = user.email else {return}
//        let database = Firestore.firestore()
//        var userProfile: [String: Any] = [:]
//        userProfile = [ "id": user.uid,
//                        "email": email,
//                        "name" : name
//        ]
//        if !locationURL.isEmpty {
//            userProfile["profileURL"] = locationURL
//        }
//        let operations = BlockOperation {
//            database.collection(FirebaseLocations.userProfiles.rawValue).addDocument(data: userProfile) { (error) in
//                if let error = error {
//                    completion(.failure(error))
//                } else {
//                    var firebaseUser = FirebaseUser()
//                    firebaseUser.id = user.uid
//                    firebaseUser.name = name
//                    firebaseUser.email = email
//                    firebaseUser.profileImage = locationURL
//                    completion(.success(firebaseUser))
//                }
//            }
//        }
//    }
//    
//    // Create profile
//    func createProfile(name: String, user: Firebase.User, locationURL: String, completion: @escaping(Result<FirebaseUser,Error>)->Void){
//        guard let email = user.email else {return}
//        let database = Firestore.firestore()
//        var userProfile: [String: Any] = [:]
//        userProfile = [ "id": user.uid,
//                        "email": email,
//                        "name" : name
//        ]
//        if !locationURL.isEmpty {
//            userProfile["profileURL"] = locationURL
//        }
//        database.collection(FirebaseLocations.userProfiles.rawValue).addDocument(data: userProfile) { (error) in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                var firebaseUser = FirebaseUser()
//                firebaseUser.id = user.uid
//                firebaseUser.name = name
//                firebaseUser.email = email
//                firebaseUser.profileImage = locationURL
//                completion(.success(firebaseUser))
//            }
//        }
//    }
//    
//    // save Profile Image
//    func updateProfileImage(userID: String, imageData: Data, completion: @escaping(Result<String,Error>)->Void){
//        let storage = Storage.storage()
//        let storageReferance = storage.reference()
//        let storageProfileReference = storageReferance.child(FirebaseLocations.profileImages.rawValue).child(userID)
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpg"
//        storageProfileReference.putData(imageData, metadata: metaData) { (storageMetaData, error) in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                storageProfileReference.downloadURL { (url, error) in
//                    if let error = error {
//                        completion(.failure(error))
//                    } else if let url = url?.absoluteString {
//                        completion(.success(url))
//                    }
//                }
//            }
//        }
//    }
//
    
}
