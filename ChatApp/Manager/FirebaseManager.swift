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
            print("no user found")
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
    func createProfile(name: String, user: Firebase.User, locationURL: String, completion: @escaping(Result<FirebaseUser?,Error>)->Void){
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
            let firebaseUser = FirebaseUser(id: user.uid, email: email, name: name, profileImage: userProfile["profileURL"] as? String)
            print("User profile for register: \(userProfile)")
            if let error = error {
                print("Profile image could not be saved....")
                completion(.failure(error))
            } else {
                completion(.success(firebaseUser))
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
    // reset password
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
}

