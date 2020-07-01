//
//  CallView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct CallView: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("Call Tab")
            }
            .navigationBarTitle("Calls", displayMode: .inline)
        }
    }
}

struct CallView_Previews: PreviewProvider {
    static var previews: some View {
        CallView()
    }
}
