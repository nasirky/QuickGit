//
//  Store+App.swift
//  QuickGit
//
//  Created by Paul Kraft on 15.08.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Foundation

typealias AppStore = Store<AppState, AppAction>

struct AppState {

    var githubService: GitHubService?

    var isLoggedIn: Bool {
        githubService != nil
    }

}

enum AppAction {
    case storedLogin
    case login(code: String)
    case logout
}

extension Reducer where State == AppState, Action == AppAction {

    static func appReducer() -> Reducer {
        let loginService: LoginService = DefaultLoginService()

        return Reducer { state, action in
            switch action {
            case .storedLogin:
                return loginService.storedLogin()
                    .map { information in
                        Change { $0.githubService = DefaultGitHubService(information: information) }
                    }
                    .ignoreFailure()
            case let .login(code):
                return loginService.login(code: code)
                    .map { information in
                        Change { $0.githubService = DefaultGitHubService(information: information) }
                    }
                    .ignoreFailure()
            case .logout:
                loginService.logout()
                return .just(Change { $0.githubService = nil })
            }
        }
    }

}
