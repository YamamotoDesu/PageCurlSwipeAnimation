//
//  ContentView.swift
//  PageCurlSwipeAnimation
//
//  Created by 山本響 on 2023/03/29.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationBarTitle("Peel Effect")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
