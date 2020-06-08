//
//  MoreModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI
// MARK:- More List for more tab
struct MoreList: Identifiable{
    var id = UUID()
    var title: String = ""
    var section: [MoreListSection] = []
}
// MARK:- More List Section
struct MoreListSection: Identifiable{
    var id = UUID()
    var title: MoreListSectionType
    var rows: [MoreListRow] {
        switch title{
        case .about:
            return [
                .init(title: .theApp, targetView: AnyView(AboutTheAppView())),
                .init(title: .appVersion, targetView: AnyView(AppVersionView())),
                .init(title: .appFeedback, targetView: AnyView(AppFeedbackView())),
                //.init(title: .disclaimer, targetView: AnyView(DisclaimerView()))
            ]
        case .myAccount:
                return [
                    .init(title: .logout, shouldNavigate: false)
                ]
        case .adminMenu:
//            if UserDefaults.standard.getUserType() == .owner || UserDefaults.standard.getUserType() == .superUser {
//                return [
//                    .init(title: .manageGroups),
//                    .init(title: .manageUsers),
//                    .init(title: .managePlaces)
//                ]
//            } else {
                return [
                ]
            //}
        }
    }
}
// MARK:- More List Item
struct MoreListRow: Identifiable{
    var id = UUID()
    var title: MoreListRowType
    var targetView: AnyView = AnyView(EmptyView())
    var shouldNavigate = true
}
// MARK:- Static title for More Sections
enum MoreListSectionType: String {
    case about
    case myAccount
    case adminMenu
}
// MARK:- Static title for More Items(rows)
enum MoreListRowType: String{
    case appFeedback
    case theApp
    case appVersion
    case disclaimer
    case login
    case register
    case logout
    var textColor: Color? {
        switch self {
        case .logout: return .red
        default: return nil
        }
    }
}
