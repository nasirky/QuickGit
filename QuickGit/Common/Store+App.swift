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

    var repositories = [Repository]()

    var profile: Profile?
    var selectedRepositoryContributors = [User]()
    var selectedRepositoryIssues = [Issue]()
    var selectedRepositoryPullRequests = [PullRequest]()
    var selectedRepositoryLanguages = [String: Int]()

    var selectedIssueComments = [IssueComment]()

    var isLoggedIn: Bool {
        githubService != nil
    }

}

enum AppAction {

    case storedLogin
    case login(code: String)
    case logout

    case reloadProfile
    case reloadRepositories
    case reloadContributors(Repository)
    case reloadIssues(Repository)
    case reloadPullRequests(Repository)
    case reloadLanguages(Repository)
    case clearSelectedRepository

    case reloadComments(Repository, Issue)
    case clearSelectedIssueComments

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
            case .reloadProfile:
                guard let service = state.githubService else {
                    return .empty()
                }
                return service.fetchProfile()
                    .map { profile in Change { $0.profile = profile } }
                    .ignoreFailure()
            case .reloadRepositories:
                guard let service = state.githubService else {
                    return .empty()
                }
                return service.fetchRepositories()
                    .map { repositories in Change { $0.repositories = repositories } }
                    .ignoreFailure()
            case let .reloadIssues(repository):
                guard let service = state.githubService else {
                    return .empty()
                }
                return service.fetchIssues(for: repository)
                    .map { issues in Change { $0.selectedRepositoryIssues = issues } }
                    .ignoreFailure()
            case let .reloadContributors(repository):
                guard let service = state.githubService else {
                    return .empty()
                }
                return service.fetchContributors(for: repository)
                    .map { contributors in Change { $0.selectedRepositoryContributors = contributors } }
                    .ignoreFailure()
            case let .reloadPullRequests(repository):
                guard let service = state.githubService else {
                    return .empty()
                }
                return service.fetchPullRequest(for: repository)
                    .map { prs in Change { $0.selectedRepositoryPullRequests = prs } }
                    .ignoreFailure()
            case let .reloadLanguages(repository):
                guard let service = state.githubService else {
                    return .empty()
                }
                return service.fetchLanguages(for: repository)
                    .map { languages in Change { $0.selectedRepositoryLanguages = languages } }
                    .ignoreFailure()
            case .clearSelectedRepository:
                return .just(
                    Change {
                        $0.selectedRepositoryPullRequests = []
                        $0.selectedRepositoryContributors = []
                        $0.selectedRepositoryIssues = []
                        $0.selectedRepositoryLanguages = [:]
                    }
                )
            case let .reloadComments(repository, issue):
                guard let service = state.githubService else {
                    return .empty()
                }
                return service.fetchComments(for: issue, in: repository)
                    .map { comments in Change { $0.selectedIssueComments = comments } }
                    .ignoreFailure()
            case .clearSelectedIssueComments:
                return .just(Change { $0.selectedIssueComments = [] })
            }
        }
    }

}
