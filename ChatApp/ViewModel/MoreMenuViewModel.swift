//
//  MoreMenuViewModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

class MoreMenuViewModel: ObservableObject {
    @Published var moreMenuList: MoreList = MoreList()
    init(){
        let aboutMyApp = MoreListSection(title: .about)
        self.moreMenuList.section = [aboutMyApp]
    }
}

