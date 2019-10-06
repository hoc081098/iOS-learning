//
//  ContentView.swift
//  Learn SwiftUI
//
//  Created by Petrus Nguyễn Thái Học on 10/5/19.
//  Copyright © 2019 Petrus Nguyễn Thái Học. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var data = (1...100).map { String($0) }

    var body: some View {
        VStack {
            Button("Click") {
                self.data = self.data.map { "\($0) #" }
            }
            List {
                ForEach.init(data, id: \.self, content: { e in
                    Text(e)
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
