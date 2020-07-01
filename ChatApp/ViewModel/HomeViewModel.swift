//
//  HomeViewModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 21/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

class HomeViewModel: BaseViewModel{
    override init(firebaseViewModel: FirebaseViewModel, mainViewModel: MainViewModel){
        super.init(firebaseViewModel: firebaseViewModel, mainViewModel: mainViewModel)
    }
    func logOut(completion: @escaping(Bool)->Void){
        self.firebaseViewModel.logOut { (result) in
            switch result{
            case .success(_):
                completion(true)
            case .failure(let error):
                self.message = error.localizedDescription
                self.isError = true
                completion(false)
            }
        }
    }
}
