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
    func registerUser(name: String, profileImage: UIImage?, email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func logoutUser(completion: @escaping (Result<Bool, Error>) -> Void)
    func loginUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func sendPasswordResetEmail(email: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class FirebaseViewModel: ObservableObject {
    @Published var isLogedIn: Bool = false
    @Published var currentUser: Firebase.User?
    @Published var profileImage: UIImage?
    
    init(){
        if let user = Auth.auth().currentUser {
            self.currentUser = user
            self.isLogedIn = true
            self.loadProfileImage()
        }
    }
    func clearData(){
        self.isLogedIn = false 
        self.currentUser = nil
        self.profileImage = nil
    }
    private func loadProfileImage(){
        if let userID = Auth.auth().currentUser?.uid {
            let storage = Storage.storage()
            let storageReferance = storage.reference(forURL: "gs://perseus-chat-app.appspot.com/")
            let storageProfileReference = storageReferance.child("profile").child(userID)
            storageProfileReference.getData(maxSize: 3*1024*1024) { (data, error) in
                if let data = data, let image = UIImage(data: data) {
                    self.profileImage = image
                } else if let error = error {
                    print("Error loading image from firebase: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension FirebaseViewModel: FirebaseOperations {
    func registerUser(name: String, profileImage: UIImage?, email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error{
                completion(.failure(error))
            } else if let data = authDataResult {
                let profileChange = Auth.auth().currentUser?.createProfileChangeRequest()
                profileChange?.displayName = name
                guard let imageData = profileImage?.jpegData(compressionQuality: 0.35), let userID = Auth.auth().currentUser?.uid else { return }
                let storage = Storage.storage()
                let storageReferance = storage.reference()
                let storageProfileReference = storageReferance.child("profile").child(userID)
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"
                storageProfileReference.putData(imageData, metadata: metaData) { (storageMetaData, error) in
                    if let error = error {
                        print("ignore error if failed to save profile image ??: \(error.localizedDescription)")
                        completion(.success(false))
                    } else {
                        storageProfileReference.downloadURL { (url, error) in
                            if let error = error {
                                print("ignore error if failed to save profile image ??: \(error.localizedDescription)")
                                completion(.success(false))
                            } else if let url = url {
                                profileChange?.photoURL = url
                                profileChange?.commitChanges(completion: { (error) in
                                    if let error = error {
                                        print("unable to set profile ..: \(error.localizedDescription)")
                                        completion(.success(false))
                                    }
                                    else {
                                        self.currentUser =  data.user
                                        self.isLogedIn = true
                                        self.profileImage = profileImage
                                        completion(.success(true))
                                    }
                                })
                                completion(.success(true))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func logoutUser(completion: @escaping (Result<Bool, Error>) -> Void){
        do { try Auth.auth().signOut()
            completion(.success(true))
        }
        catch let err{
            completion(.failure(err))
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error{
                completion(.failure(error))
            } else if let data = authDataResult {
                self.currentUser =  data.user
                self.isLogedIn = true
                self.loadProfileImage()
                completion(.success(true))
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
}
