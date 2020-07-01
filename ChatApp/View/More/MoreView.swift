//
//  MoreView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct MoreView: View {
    @ObservedObject var viewModel: MoreViewModel
    var body: some View {
        NavigationView{
            List {
                ForEach(self.viewModel.list) { item in
                    Section(header: Text(item.title.rawValue.titleCase()).bold().frame(height: 50)) {
                        ForEach(item.rows, id: \.id) { row in
                            MoreListItemView(row: row)
                        }
                    }
                }.navigationBarTitle(Text("More").bold(),displayMode: .inline)
            }
        }.onAppear {
            UITableView.appearance().tableFooterView = UIView()
        }
    }
}

struct MoreListItemView: View {
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

