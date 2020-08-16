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

    @ObservedObject var viewModel: ViewModel<LoginViewModel.Input, LoginViewModel.State>

    // MARK: Views

    var body: some View {
        Group {
            if viewModel.state.isLoggedIn {
                HomeView(viewModel: viewModel.state.homeViewModel!)
            } else {
                LoginView(viewModel: viewModel)
            }
        }
        .onAppear(perform: storedLogin)
        .accentColor(Color("Accent"))
    }

    // MARK: Helpers

    private func storedLogin() {
        viewModel.trigger(.storedLogin)
    }

}
