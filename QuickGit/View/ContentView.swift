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

    @State var loginInformation: LoginInformation? = nil
    @State var cancellables = Set<AnyCancellable>()

    let loginService: LoginService

    var body: some View {
        Group {
            if loginInformation == nil {
                LoginView(information: $loginInformation,
                          loginService: loginService)
            }
            loginInformation.map { information in
                HomeView(loginInformation: $loginInformation,
                         loginService: loginService,
                         gitHubService: DefaultGitHubService(information: information))
            }
        }
        .onAppear(perform: storedLogin)
    }

    private func storedLogin() {
        loginService.storedLogin()
        .ignoreFailure()
        .map(Optional.some)
        .assign(to: \.loginInformation, on: self)
        .store(in: &cancellables)
    }

}
