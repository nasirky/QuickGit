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

    let loginService: LoginService

    @State private var loginInformation: LoginInformation?
    @State private var cancellables = Set<AnyCancellable>()

    // MARK: Views

    var body: some View {
        When(exists: loginInformation,
             then: homeView,
             else: loginView)
        .onAppear(perform: storedLogin)
        .accentColor(Color("Accent"))
    }

    private var loginView: some View {
        LoginView(information: $loginInformation,
                  loginService: loginService)
    }

    private func homeView(_ information: LoginInformation) -> some View {
        HomeView(loginInformation: $loginInformation,
                 loginService: loginService,
                 gitHubService: DefaultGitHubService(information: information))
    }

    // MARK: Helpers

    private func storedLogin() {
        loginService.storedLogin()
        .print()
        .ignoreFailure()
        .map(Optional.some)
        .assign(to: \.loginInformation, on: self)
        .store(in: &cancellables)
    }

}
