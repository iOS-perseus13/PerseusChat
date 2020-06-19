//
//  MoreView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct MoreView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State var list: [MoreListSection] = []
    
    var body: some View {
        NavigationView{
            List {
                ForEach(list) { item in
                    Section(header: Text(item.title.rawValue.titleCase()).bold().frame(height: 50)) {
                        ForEach(item.rows, id: \.id) { row in
                            MoreListItemView(userViewModel: self.userViewModel, row: row)
                        }
                    }
                }.navigationBarTitle(Text("More").bold(),displayMode: .inline)
            }
        }.onAppear {
            UITableView.appearance().tableFooterView = UIView()
            self.list = self.createMoreList()
        }
    }
    private func createMoreList()->[MoreListSection]{
       // let myAccountSection = MoreListSection(title: .myAccount)
        let adminSection = MoreListSection(title: .adminMenu)
        let aboutMyApp = MoreListSection(title: .about)
        if adminSection.rows.isEmpty {
            return [aboutMyApp]
        } else {
            return [adminSection, aboutMyApp]
        }
    }
}

struct MoreListItemView: View {
    @ObservedObject var userViewModel: UserViewModel
    var row: MoreListRow
    var body: some View {
        VStack{
            if row.shouldNavigate {
                NavigationLink(destination: row.targetView){
                    Text(row.title.rawValue.titleCase())
                        .foregroundColor(row.title.textColor)
                }.navigationBarTitle("")
            } else {
                Text(row.title.rawValue.titleCase())
                    .foregroundColor(row.title.textColor)
                    .onTapGesture {
//                        self.firebaseViewModel.logoutUser { (_) in
//                            self.firebaseViewModel.clearData()
//                        }
                }
            }
        }
    }
}

