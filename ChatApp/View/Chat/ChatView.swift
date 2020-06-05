//
//  ChatView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct ChatView: View {
    @State var searchChatRoom: String = ""
    @State var chatText: String = ""
    @State var groupList: [String] = ["Gr 1", "Gr2", "Group 3", "Group3",
    "Gr 1", "Gr2", "Group 3", "Group3",
    "Gr 1", "Gr2", "Group 3", "Group3",
    "Gr 1", "Gr2", "Group 3", "Group3"]
    @State var editMode = EditMode.inactive
    @State var selection = Set<String>()
    var body: some View {
        NavigationView{
            VStack {
                // Search bar
                HStack{
                    Image(systemName: "magnifyingglass")
                    TextField("Search",text: self.$searchChatRoom)
                    
                } .background(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.blue, lineWidth: 1)
                ).padding()
                
                // Group list
                List(selection: $selection){
                    ForEach(self.groupList, id: \.self){ item in
                        ChatRoomView(chatRow: item)
                    }
                }
                
            }.navigationBarTitle("Chat",displayMode: .inline)
                .navigationBarItems(
                    leading: deleteButton, trailing: editButton
            )
                .environment(\.editMode, self.$editMode)
            
            }.padding()
        .onAppear{
            UITableView.appearance().tableFooterView = UIView()
        }
    }
    func deleteSelected(){
        for id in selection{
            if let index = self.groupList.lastIndex(where: { $0 == id}) {
                self.groupList.remove(at: index)
            }
        }
        selection = Set<String>()
    }
    
    private var deleteButton: some View{
        switch editMode {
        
        case .active:
            return AnyView(
                Button(action: deleteSelected) {
                    Image(systemName: "trash")
            })
        default:
            return AnyView( EmptyView())
        }
    }
     private var editButton: some View{
         switch editMode {
         
         case .inactive:
             return AnyView(
                Button(action: {
                    self.editMode = .active
                    self.selection = Set<String>()
                }
                    ) {
                     Text("Edit")
             })
         default:
             return AnyView(
                Button(action: {
                   self.editMode = .inactive
                   self.selection = Set<String>()
               }
                   ) {
                    Text("Done")
            }
            )
         }
     }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

struct ChatRoomView: View {
    @State var chatRow: String
    var body: some View {
        HStack(alignment: .center, spacing: 30){
            
            Image(systemName: "text.bubble.fill")
                .resizable()
                .frame(width: 35, height: 35)
            VStack(spacing: 0){
                HStack{
                    Text("Group Name")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Text("Last update time")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                HStack{
                    
                    Text("Two lined text dfskdfjdskfjsk jfskdfjskd fjdskfj kfjdskfj dskfjk dfjdskf j....")
                        .lineLimit(2)
                        .opacity(0.5)
                    Spacer()
                }
            }
        }//.padding(10)
    }
}

struct TextView: View {
    @State var groupList: [String] = ["Gr 1", "Gr2", "Group 3", "Group3"]
    var body: some View{
        List{
            ForEach(self.groupList, id: \.self){ item in
                ChatRoomView(chatRow: item)
            }
        }
    }
}
