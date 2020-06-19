//
//  AppTabs.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

/*
 Tab Types enum
 1. Home
 2. Call
 3. Message
 4. More
 */
enum TabTypes: String{
    case home
    case call
    case message
    case more
    var tabIndex: Int {
        switch self {
        case .home: return 0
        case .call: return 1
        case .message: return 2
        case .more: return 3
        }
    }
    var image: String {
        switch self{
        case .home: return "house"
        case .call: return "phone"
        case .message: return "message"
        case .more: return "circle.grid.2x2"
        }
    }
    
}
/*
 Colors for tab
 */

enum TabColor {
    enum SelectionType{
        case selected
        case notSelected
    }
    case foreground (selectionTYpe: SelectionType)
    case background (selectionTYpe: SelectionType)
    var color: Color{
        switch self{
        case .background(selectionTYpe: .selected): return .red
        case .background(selectionTYpe: .notSelected): return .clear
        case .foreground(selectionTYpe: .selected): return .white
        case .foreground(selectionTYpe: .notSelected): return .blue
        }
    }
}

struct HomeTab: View {
    @ObservedObject var userViewModel: UserViewModel
    var body: some View {
        HomeView(userViewModel: self.userViewModel)
    }
}



struct CallTab: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("Call Tab")
            }
            .navigationBarTitle("Calls", displayMode: .inline)
        }
        
    }
}



struct MoreTab: View {
    @ObservedObject var userViewModel: UserViewModel
    var body: some View {
        MoreView(userViewModel: self.userViewModel)
    }
}

