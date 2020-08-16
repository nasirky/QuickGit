//
//  ContentView.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import SwiftUI

struct ContentView: View {

    // MARK: Stored properties

    @ObservedObject var store: AppStore

    // MARK: Views

    var body: some View {
        Group {
            if store.state.isLoggedIn {
                HomeView(store: store, viewModel: store.state.homeViewModel!)
            } else {
                LoginView(store: store)
            }
        }
        .onAppear(perform: storedLogin)
        .accentColor(Color("Accent"))
    }

    // MARK: Helpers

    private func storedLogin() {
        store.send(.storedLogin(store: store))
    }

}
