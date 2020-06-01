//
//  TabbedView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
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

/*
 Tabbed View
 1. Home Tab
 2. Call Tab
 3. Message Tab
 4. More Tab
 */

struct TabbedView: View {
    @State var index: Int = 0
    @State var isTabSelected: Bool = false
    var body: some View {
        HStack (spacing: 0){
            // Home Tab
            
            TabTypeView(tabType: .home, tabIndex: self.$index)
            
            Spacer()
            // Call Tab
            TabTypeView(tabType: .call, tabIndex: self.$index)
            Spacer()
            // Message Tab
            TabTypeView(tabType: .message, tabIndex: self.$index)
            Spacer()
            // More Tab
            TabTypeView(tabType: .more, tabIndex: self.$index)
            
        }
        .background(Color.clear)
//
    }
}

struct TabbedView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedView()
    }
}

struct TabTypeView: View {
    @State var tabType: TabTypes
    @Binding var tabIndex: Int
    var body: some View {
        VStack{
            Button(action: {
                switch self.tabType {
                case .home: self.tabIndex = 0
                case .call: self.tabIndex = 1
                case .message: self.tabIndex = 2
                case .more: self.tabIndex = 3
                }
            }) {
                Image(systemName: tabType.image)
                    // tab icon image size
                    .font(.title)
                    // tab icon image color
                    .foregroundColor(
                        self.tabIndex == tabType.tabIndex ?
                            TabColor.foreground(selectionTYpe: .selected).color :
                            TabColor.foreground(selectionTYpe: .notSelected).color)
                    .padding()
                    // tab icon background color
                    .background(
                        self.tabIndex == tabType.tabIndex ?
                            TabColor.background(selectionTYpe: .selected).color :
                            TabColor.background(selectionTYpe: .notSelected).color)
                    // create a circle shaped look for tab icons
                    .clipShape(Circle())
                    // decrese the bottom indent, so that the tab text comes closer
                    .padding(.bottom, -10)
            }
            // text for the tab
            Text(tabType.rawValue.titleCase())
        }
            // if the tab is selected
            .onTapGesture {
                switch self.tabType {
                case .home: self.tabIndex = 0
                case .call: self.tabIndex = 1
                case .message: self.tabIndex = 2
                case .more: self.tabIndex = 3
                }
        }
            // move the tab a bit higher than normal position
            .offset(y: self.tabIndex == tabType.tabIndex ? -20 : 0)
    }
}
