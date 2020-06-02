////
////  TabbedView.swift
////  ChatApp
////
////  Created by Sheikh Ahmed on 31/05/2020.
////  Copyright © 2020 Perseus International. All rights reserved.
////
//
//import SwiftUI
//
//
//
///*
// Tabbed View
// 1. Home Tab
// 2. Call Tab
// 3. Message Tab
// 4. More Tab
// */
//
//struct TabbedView: View {
//    @ObservedObject var userViewModel: UserViewModel
//    @State var index: Int = 0
//    @State var isTabSelected: Bool = false
//    var body: some View {
//        HStack (spacing: 0){
//            // Home Tab
//            
//            TabTypeView(tabType: .home, tabIndex: self.$index)
//                .onTapGesture {
//                    self.userViewModel.tabIndex = 0
//            }
//            
//            Spacer()
//            // Call Tab
//            TabTypeView(tabType: .call, tabIndex: self.$index)
//            .onTapGesture {
//                self.userViewModel.tabIndex = 1
//            }
//            Spacer()
//            // Message Tab
//            TabTypeView(tabType: .message, tabIndex: self.$index)
//            .onTapGesture {
//                self.userViewModel.tabIndex = 2
//            }
//            Spacer()
//            // More Tab
//            TabTypeView(tabType: .more, tabIndex: self.$index)
//            .onTapGesture {
//                self.userViewModel.tabIndex = 3
//            }
//            
//        }
//        .background(Color.clear)
////
//    }
//}
//
//
//
//struct TabTypeView: View {
//    @State var tabType: TabTypes
//    @Binding var tabIndex: Int
//    var body: some View {
//        VStack{
//            Button(action: {
//                switch self.tabType {
//                case .home: self.tabIndex = 0
//                case .call: self.tabIndex = 1
//                case .message: self.tabIndex = 2
//                case .more: self.tabIndex = 3
//                }
//            }) {
//                Image(systemName: tabType.image)
//                    // tab icon image size
//                    .font(.title)
//                    // tab icon image color
//                    .foregroundColor(
//                        self.tabIndex == tabType.tabIndex ?
//                            TabColor.foreground(selectionTYpe: .selected).color :
//                            TabColor.foreground(selectionTYpe: .notSelected).color)
//                    .padding()
//                    // tab icon background color
//                    .background(
//                        self.tabIndex == tabType.tabIndex ?
//                            TabColor.background(selectionTYpe: .selected).color :
//                            TabColor.background(selectionTYpe: .notSelected).color)
//                    // create a circle shaped look for tab icons
//                    .clipShape(Circle())
//                    // decrese the bottom indent, so that the tab text comes closer
//                    .padding(.bottom, -10)
//            }
//            // text for the tab
//            Text(tabType.rawValue.titleCase())
//        }
//            // if the tab is selected
//            .onTapGesture {
//                switch self.tabType {
//                case .home: self.tabIndex = 0
//                case .call: self.tabIndex = 1
//                case .message: self.tabIndex = 2
//                case .more: self.tabIndex = 3
//                }
//        }
//            // move the tab a bit higher than normal position
//            .offset(y: self.tabIndex == tabType.tabIndex ? -20 : 0)
//    }
//}
