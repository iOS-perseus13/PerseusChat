//
//  MoreViewModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 22/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import Foundation
class MoreViewModel: ObservableObject{
    @Published var list: [MoreListSection] = []
    
    init(){
        self.createMoreList()
    }
    func createMoreList(){
       // let myAccountSection = MoreListSection(title: .myAccount)
        let adminSection = MoreListSection(title: .adminMenu)
        let aboutMyApp = MoreListSection(title: .about)
        if adminSection.rows.isEmpty {
            self.list = [aboutMyApp]
        } else {
            self.list = [adminSection, aboutMyApp]
        }
    }
}
