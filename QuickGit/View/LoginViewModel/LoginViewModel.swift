//
//  LoginViewModel.swift
//  QuickGit
//
//  Created by Nasir on 16.08.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Foundation
import Combine

class LoginViewModel: ViewModel<LoginViewModel.Input, LoginViewModel.State> {
    private let loginService: LoginService = DefaultLoginService()
    private var cancellables: Set<AnyCancellable> = .init()

    init() {
        super.init(state: .init())
    }

    override func trigger(_ input: Input) {
        switch input {
            case .storedLogin:
                return loginService.storedLogin()
                    .ignoreFailure()
                    .sink { [unowned self] information in
                        let githubService = DefaultGitHubService(information: information)
                        self.state.homeViewModel = HomeViewModel(parentViewModel: self, gitHubService: githubService)
                    }
                .store(in: &cancellables)
            case let .login(code):
                return loginService.login(code: code)
                    .ignoreFailure()
                    .sink { [unowned self] information in
                            let githubService = DefaultGitHubService(information: information)
                        self.state.homeViewModel = HomeViewModel(parentViewModel: self, gitHubService: githubService)
                    }
                .store(in: &cancellables)
            case .logout:
                loginService.logout()
                state.homeViewModel = nil
        }
    }
}

extension LoginViewModel {
    enum Input {
        case storedLogin
        case login(code: String)
        case logout
    }
}

extension LoginViewModel {
    struct State {
        var homeViewModel: ViewModel<HomeViewModel.Input, HomeViewModel.State>?

        var isLoggedIn: Bool { homeViewModel != nil }
    }
}
